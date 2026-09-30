class RemoveDoctorPrefixFromNames < ActiveRecord::Migration[8.1]
  def up
    # 1. Clean DoctorProfile records
    if column_exists?(:doctor_profiles, :name)
      DoctorProfile.where("name LIKE 'Dr. %' OR name LIKE 'dr. %'").find_each do |doctor|
        cleaned_name = doctor.name.sub(/\ADr\.\s*/i, "").strip
        doctor.update_column(:name, cleaned_name)
      end
    end

    # 2. Clean User records
    if column_exists?(:users, :name)
      User.where("name LIKE 'Dr. %' OR name LIKE 'dr. %'").find_each do |user|
        cleaned_name = user.name.sub(/\ADr\.\s*/i, "").strip
        user.update_column(:name, cleaned_name)
      end
    end
  end

  def down
    # Irreversible as we don't track which records originally had the prefix
  end
end