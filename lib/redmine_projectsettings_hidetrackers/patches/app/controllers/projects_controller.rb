
module ProjectSettingsHideTrackers
	module ProjectsControllerPatch
		def self.included(base)
			base.extend(ClassMethods)
			base.send(:include, InstanceMethods)

			base.class_eval do
				alias_method_chain :settings, :projectsettings_hidetrackers
				alias_method_chain :new,      :projectsettings_hidetrackers
			end
		end

		module ClassMethods
		end

		module InstanceMethods
			def settings_with_projectsettings_hidetrackers
				settings_without_projectsettings_hidetrackers
				@trackers = [] if !User.current.allowed_to?(:manage_trackers, @project) && !User.current.admin?
			end
			def new_with_projectsettings_hidetrackers
				new_without_projectsettings_hidetrackers
				@trackers = [] unless User.current.admin?
			end
		end
	end
end

ProjectsController.send(:include, ProjectSettingsHideTrackers::ProjectsControllerPatch)

