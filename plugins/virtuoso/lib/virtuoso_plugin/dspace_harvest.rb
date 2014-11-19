#inspired by https://github.com/code4lib/ruby-oai/blob/master/lib/oai/harvester/harvest.rb
class VirtuosoPlugin::DspaceHarvest

  def initialize(environment, dspace_uri = nil)
    @environment = environment
    @dspace_uri = dspace_uri
  end

  attr_reader :environment

  def plugin
    @plugin ||= VirtuosoPlugin.new(self)
  end

  delegate :settings, :to => :plugin

  def dspace_client
    @dspace_client ||= OAI::Client.new("#{@dspace_uri}/oai/request")
  end

  def triplify(record)
    metadata = VirtuosoPlugin::DublinCoreMetadata.new(record.metadata)
    subject_identifier = extract_identifier(record)
    puts "triplify #{subject_identifier}"

    settings.ontology_mapping.each do |mapping|
      values = [metadata.extract_field(mapping[:source])].flatten.compact
      values.each do |value|
        query = RDF::Virtuoso::Query.insert_data([RDF::URI.new(subject_identifier), RDF::URI.new(mapping[:target]), value]).graph(RDF::URI.new(@dspace_uri))
        plugin.virtuoso_client.insert(query)
      end
    end
  end

  def run
    harvest_time = Time.now.utc
    params = settings.last_harvest ? {:from => settings.last_harvest.utc} : {}
    puts "starting harvest #{params} #{@dspace_uri} #{settings.virtuoso_uri}"
    begin
      records = dspace_client.list_records(params)
      records.each do |record|
        triplify(record)
      end
    rescue OAI::Exception => ex
      puts ex.to_s
      if ex.code != 'noRecordsMatch'
        puts "unexpected error"
        raise ex
      end
    end
    settings.last_harvest = harvest_time
    settings.save!
    puts "ending harvest #{harvest_time}"
  end

  def self.harvest_all(environment, from_start)
    settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin)
    if defined?(settings.dspace_servers)
      settings.dspace_servers.each do |k, v| 
        harvest = VirtuosoPlugin::DspaceHarvest.new(environment, k[:dspace_uri])
        harvest.start(from_start)
      end
    end  
  end

  def start(from_start = false)
    if find_job.empty?
      if from_start
        settings.last_harvest = nil
        settings.save!
      end
      job = VirtuosoPlugin::DspaceHarvest::Job.new(@environment.id, @dspace_uri)
      Delayed::Job.enqueue(job)
    end
  end

  def find_job
    Delayed::Job.where(:handler => "--- !ruby/struct:VirtuosoPlugin::DspaceHarvest::Job\nenvironment_id: #{@environment.id}\ndspace_uri: #{@dspace_uri}\n")
  end

  class Job < Struct.new(:environment_id, :dspace_uri)
    def perform
      environment = Environment.find(environment_id)
      harvest = VirtuosoPlugin::DspaceHarvest.new(environment, dspace_uri)
      harvest.run
    end
  end

  protected

  def extract_identifier(record)
    parsed_identifier = /oai:(.+):(\d+\/\d+)/.match(record.header.identifier)
    "#{@dspace_uri}/handle/#{parsed_identifier[2]}"
  end

end
