class AddMembersJob < Struct.new(:people_ids, :profile_id, :locale)

  def perform
    Noosfero.with_locale(locale) do

      profile = Profile.find(profile_id)
      profile.add_members people_ids

    end
  end
end
