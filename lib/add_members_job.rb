class AddMembersJob < Struct.new(:people_ids, :profile_id, :locale)

  def perform
    Noosfero.with_locale(locale) do

      profile = Profile.find(profile_id)

      if people_ids.first =~ /\@/
        profile.add_members_by_email people_ids
      else
        profile.add_members_by_id people_ids
      end

    end
  end
end
