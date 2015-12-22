# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151221105330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abuse_reports", force: :cascade do |t|
    t.integer  "reporter_id"
    t.integer  "abuse_complaint_id"
    t.text     "content"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "academic_infos", force: :cascade do |t|
    t.integer "person_id"
    t.string  "lattes_url"
  end

  create_table "action_tracker", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "user_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.text     "params"
    t.string   "verb"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", default: 0
    t.boolean  "visible",        default: true
  end

  add_index "action_tracker", ["target_id", "target_type"], name: "index_action_tracker_on_dispatcher_id_and_dispatcher_type", using: :btree
  add_index "action_tracker", ["user_id", "user_type"], name: "index_action_tracker_on_user_id_and_user_type", using: :btree
  add_index "action_tracker", ["verb"], name: "index_action_tracker_on_verb", using: :btree

  create_table "action_tracker_notifications", force: :cascade do |t|
    t.integer "action_tracker_id"
    t.integer "profile_id"
  end

  add_index "action_tracker_notifications", ["action_tracker_id"], name: "index_action_tracker_notifications_on_action_tracker_id", using: :btree
  add_index "action_tracker_notifications", ["profile_id", "action_tracker_id"], name: "index_action_tracker_notif_on_prof_id_act_tracker_id", unique: true, using: :btree
  add_index "action_tracker_notifications", ["profile_id"], name: "index_action_tracker_notifications_on_profile_id", using: :btree

  create_table "analytics_plugin_page_views", force: :cascade do |t|
    t.string   "type"
    t.integer  "visit_id"
    t.integer  "track_id"
    t.integer  "referer_page_view_id"
    t.string   "request_id"
    t.integer  "user_id"
    t.integer  "session_id"
    t.integer  "profile_id"
    t.text     "url"
    t.text     "referer_url"
    t.text     "user_agent"
    t.string   "remote_ip"
    t.datetime "request_started_at"
    t.datetime "request_finished_at"
    t.datetime "page_loaded_at"
    t.integer  "time_on_page",         default: 0
    t.text     "data",                 default: "--- {}\n"
  end

  add_index "analytics_plugin_page_views", ["profile_id"], name: "index_analytics_plugin_page_views_on_profile_id", using: :btree
  add_index "analytics_plugin_page_views", ["referer_page_view_id"], name: "index_analytics_plugin_page_views_on_referer_page_view_id", using: :btree
  add_index "analytics_plugin_page_views", ["request_id"], name: "index_analytics_plugin_page_views_on_request_id", using: :btree
  add_index "analytics_plugin_page_views", ["session_id"], name: "index_analytics_plugin_page_views_on_session_id", using: :btree
  add_index "analytics_plugin_page_views", ["url"], name: "index_analytics_plugin_page_views_on_url", using: :btree
  add_index "analytics_plugin_page_views", ["user_id", "session_id", "profile_id", "url"], name: "analytics_plugin_referer_find", using: :btree
  add_index "analytics_plugin_page_views", ["user_id"], name: "index_analytics_plugin_page_views_on_user_id", using: :btree

  create_table "analytics_plugin_visits", force: :cascade do |t|
    t.integer "profile_id"
  end

  create_table "article_followers", force: :cascade do |t|
    t.integer  "person_id",  null: false
    t.integer  "article_id", null: false
    t.datetime "since"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_followers", ["article_id"], name: "index_article_followers_on_article_id", using: :btree
  add_index "article_followers", ["person_id", "article_id"], name: "index_article_followers_on_person_id_and_article_id", unique: true, using: :btree
  add_index "article_followers", ["person_id"], name: "index_article_followers_on_person_id", using: :btree

  create_table "article_privacy_exceptions", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "person_id"
  end

  create_table "article_versions", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "version"
    t.string   "name"
    t.string   "slug"
    t.text     "path",                 default: ""
    t.integer  "parent_id"
    t.text     "body"
    t.text     "abstract"
    t.integer  "profile_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "last_changed_by_id"
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.string   "versioned_type"
    t.integer  "comments_count"
    t.boolean  "advertise",            default: true
    t.boolean  "published",            default: true
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "children_count",       default: 0
    t.boolean  "accept_comments",      default: true
    t.integer  "reference_article_id"
    t.text     "setting"
    t.boolean  "notify_comments",      default: false
    t.integer  "hits",                 default: 0
    t.datetime "published_at"
    t.string   "source"
    t.boolean  "highlighted",          default: false
    t.string   "external_link"
    t.boolean  "thumbnails_processed", default: false
    t.boolean  "is_image",             default: false
    t.integer  "translation_of_id"
    t.string   "language"
    t.string   "source_name"
    t.integer  "license_id"
    t.integer  "image_id"
    t.integer  "position"
    t.integer  "spam_comments_count",  default: 0
    t.integer  "author_id"
    t.integer  "created_by_id"
    t.integer  "followers_count"
  end

  add_index "article_versions", ["article_id"], name: "index_article_versions_on_article_id", using: :btree
  add_index "article_versions", ["parent_id"], name: "index_article_versions_on_parent_id", using: :btree
  add_index "article_versions", ["path", "profile_id"], name: "index_article_versions_on_path_and_profile_id", using: :btree
  add_index "article_versions", ["path"], name: "index_article_versions_on_path", using: :btree
  add_index "article_versions", ["published_at", "id"], name: "index_article_versions_on_published_at_and_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "path",                 default: ""
    t.integer  "parent_id"
    t.text     "body"
    t.text     "abstract"
    t.integer  "profile_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "last_changed_by_id"
    t.integer  "version"
    t.string   "type"
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "comments_count",       default: 0
    t.boolean  "advertise",            default: true
    t.boolean  "published",            default: true
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "children_count",       default: 0
    t.boolean  "accept_comments",      default: true
    t.integer  "reference_article_id"
    t.text     "setting"
    t.boolean  "notify_comments",      default: true
    t.integer  "hits",                 default: 0
    t.datetime "published_at"
    t.string   "source"
    t.boolean  "highlighted",          default: false
    t.string   "external_link"
    t.boolean  "thumbnails_processed", default: false
    t.boolean  "is_image",             default: false
    t.integer  "translation_of_id"
    t.string   "language"
    t.string   "source_name"
    t.integer  "license_id"
    t.integer  "image_id"
    t.integer  "position"
    t.integer  "spam_comments_count",  default: 0
    t.integer  "author_id"
    t.integer  "created_by_id"
    t.boolean  "show_to_followers",    default: true
    t.integer  "followers_count",      default: 0
    t.boolean  "archived",             default: false
    t.integer  "sash_id"
    t.integer  "level",                default: 0
  end

  add_index "articles", ["comments_count"], name: "index_articles_on_comments_count", using: :btree
  add_index "articles", ["created_at"], name: "index_articles_on_created_at", using: :btree
  add_index "articles", ["hits"], name: "index_articles_on_hits", using: :btree
  add_index "articles", ["name"], name: "index_articles_on_name", using: :btree
  add_index "articles", ["parent_id"], name: "index_articles_on_parent_id", using: :btree
  add_index "articles", ["path", "profile_id"], name: "index_articles_on_path_and_profile_id", using: :btree
  add_index "articles", ["path"], name: "index_articles_on_path", using: :btree
  add_index "articles", ["profile_id"], name: "index_articles_on_profile_id", using: :btree
  add_index "articles", ["published_at", "id"], name: "index_articles_on_published_at_and_id", using: :btree
  add_index "articles", ["slug"], name: "index_articles_on_slug", using: :btree
  add_index "articles", ["translation_of_id"], name: "index_articles_on_translation_of_id", using: :btree
  add_index "articles", ["type", "parent_id"], name: "index_articles_on_type_and_parent_id", using: :btree
  add_index "articles", ["type", "profile_id"], name: "index_articles_on_type_and_profile_id", using: :btree
  add_index "articles", ["type"], name: "index_articles_on_type", using: :btree

  create_table "articles_categories", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "category_id"
    t.boolean "virtual",     default: false
  end

  add_index "articles_categories", ["article_id"], name: "index_articles_categories_on_article_id", using: :btree
  add_index "articles_categories", ["category_id"], name: "index_articles_categories_on_category_id", using: :btree

  create_table "badges_sashes", force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", default: false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id", using: :btree
  add_index "badges_sashes", ["badge_id"], name: "index_badges_sashes_on_badge_id", using: :btree
  add_index "badges_sashes", ["sash_id"], name: "index_badges_sashes_on_sash_id", using: :btree

  create_table "blocks", force: :cascade do |t|
    t.string   "title"
    t.integer  "box_id"
    t.string   "type"
    t.text     "settings"
    t.integer  "position"
    t.boolean  "enabled",         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fetched_at"
    t.boolean  "mirror",          default: false
    t.integer  "mirror_block_id"
    t.integer  "observers_id"
  end

  add_index "blocks", ["box_id"], name: "index_blocks_on_box_id", using: :btree
  add_index "blocks", ["enabled"], name: "index_blocks_on_enabled", using: :btree
  add_index "blocks", ["fetched_at"], name: "index_blocks_on_fetched_at", using: :btree
  add_index "blocks", ["type"], name: "index_blocks_on_type", using: :btree

  create_table "boxes", force: :cascade do |t|
    t.string  "owner_type"
    t.integer "owner_id"
    t.integer "position"
  end

  add_index "boxes", ["owner_id", "owner_type"], name: "index_boxes_on_owner_type_and_owner_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string  "name"
    t.string  "slug"
    t.text    "path",                      default: ""
    t.integer "environment_id"
    t.integer "parent_id"
    t.string  "type"
    t.float   "lat"
    t.float   "lng"
    t.boolean "display_in_menu",           default: false
    t.integer "children_count",            default: 0
    t.boolean "accept_products",           default: true
    t.integer "image_id"
    t.string  "acronym"
    t.string  "abbreviation"
    t.string  "display_color",   limit: 6
    t.text    "ancestry"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "categories_profiles", id: false, force: :cascade do |t|
    t.integer "profile_id"
    t.integer "category_id"
    t.boolean "virtual",     default: false
  end

  add_index "categories_profiles", ["category_id"], name: "index_categories_profiles_on_category_id", using: :btree
  add_index "categories_profiles", ["profile_id"], name: "index_categories_profiles_on_profile_id", using: :btree

  create_table "certifiers", force: :cascade do |t|
    t.string   "name",           null: false
    t.text     "description"
    t.string   "link"
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_messages", force: :cascade do |t|
    t.integer  "from_id",    null: false
    t.integer  "to_id",      null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chat_messages", ["created_at"], name: "index_chat_messages_on_created_at", using: :btree
  add_index "chat_messages", ["from_id"], name: "index_chat_messages_on_from_id", using: :btree
  add_index "chat_messages", ["to_id"], name: "index_chat_messages_on_to_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "source_id"
    t.integer  "author_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.integer  "reply_of_id"
    t.string   "ip_address"
    t.boolean  "spam"
    t.string   "source_type"
    t.string   "user_agent"
    t.string   "referrer"
    t.text     "settings"
    t.integer  "paragraph_id"
    t.integer  "group_id"
    t.string   "paragraph_uuid"
  end

  add_index "comments", ["paragraph_uuid"], name: "index_comments_on_paragraph_uuid", using: :btree
  add_index "comments", ["source_id", "spam"], name: "index_comments_on_source_id_and_spam", using: :btree

  create_table "contact_lists", force: :cascade do |t|
    t.text     "list"
    t.string   "error_fetching"
    t.boolean  "fetched",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_field_values", force: :cascade do |t|
    t.string   "customized_type", default: "",    null: false
    t.integer  "customized_id",   default: 0,     null: false
    t.boolean  "public",          default: false, null: false
    t.integer  "custom_field_id", default: 0,     null: false
    t.text     "value",           default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_field_values", ["customized_type", "customized_id", "custom_field_id"], name: "index_custom_field_values", unique: true, using: :btree

  create_table "custom_fields", force: :cascade do |t|
    t.string   "name"
    t.string   "format",          default: ""
    t.text     "default_value",   default: ""
    t.string   "customized_type"
    t.text     "extras",          default: ""
    t.boolean  "active",          default: false
    t.boolean  "required",        default: false
    t.boolean  "signup",          default: false
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_fields", ["customized_type", "name", "environment_id"], name: "index_custom_field", unique: true, using: :btree

  create_table "custom_forms_plugin_alternatives", force: :cascade do |t|
    t.string  "label"
    t.integer "field_id"
    t.boolean "selected_by_default", default: false, null: false
    t.integer "position",            default: 0
  end

  create_table "custom_forms_plugin_answers", force: :cascade do |t|
    t.text    "value"
    t.integer "field_id"
    t.integer "submission_id"
  end

  create_table "custom_forms_plugin_fields", force: :cascade do |t|
    t.string  "name"
    t.string  "slug"
    t.string  "type"
    t.string  "default_value"
    t.float   "minimum"
    t.float   "maximum"
    t.integer "form_id"
    t.boolean "mandatory",         default: false
    t.integer "position",          default: 0
    t.string  "select_field_type", default: "radio", null: false
  end

  create_table "custom_forms_plugin_forms", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "profile_id"
    t.datetime "begining"
    t.datetime "ending"
    t.boolean  "report_submissions", default: false
    t.boolean  "on_membership",      default: false
    t.string   "access"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "for_admission",      default: false
  end

  create_table "custom_forms_plugin_submissions", force: :cascade do |t|
    t.string   "author_name"
    t.string   "author_email"
    t.integer  "profile_id"
    t.integer  "form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "delivery_plugin_methods", force: :cascade do |t|
    t.integer  "profile_id"
    t.string   "name"
    t.text     "description"
    t.string   "recipient"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "postal_code"
    t.string   "state"
    t.string   "country"
    t.string   "delivery_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "fixed_cost"
    t.decimal  "free_over_price"
    t.decimal  "distribution_margin_fixed"
    t.decimal  "distribution_margin_percentage"
  end

  add_index "delivery_plugin_methods", ["delivery_type"], name: "index_delivery_plugin_methods_on_delivery_type", using: :btree
  add_index "delivery_plugin_methods", ["profile_id"], name: "index_delivery_plugin_methods_on_profile_id", using: :btree

  create_table "delivery_plugin_options", force: :cascade do |t|
    t.integer  "delivery_method_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delivery_plugin_options", ["delivery_method_id"], name: "index_delivery_plugin_options_on_delivery_method_id", using: :btree
  add_index "delivery_plugin_options", ["owner_id", "delivery_method_id"], name: "index_delivery_plugin_owner_id_delivery_method_id", using: :btree
  add_index "delivery_plugin_options", ["owner_id", "owner_type"], name: "index_delivery_plugin_options_on_owner_id_and_owner_type", using: :btree
  add_index "delivery_plugin_options", ["owner_id"], name: "index_delivery_plugin_options_on_owner_id", using: :btree
  add_index "delivery_plugin_options", ["owner_type"], name: "index_delivery_plugin_options_on_owner_type", using: :btree

  create_table "domains", force: :cascade do |t|
    t.string  "name"
    t.string  "owner_type"
    t.integer "owner_id"
    t.boolean "is_default",      default: false
    t.string  "google_maps_key"
  end

  add_index "domains", ["is_default"], name: "index_domains_on_is_default", using: :btree
  add_index "domains", ["name"], name: "index_domains_on_name", using: :btree
  add_index "domains", ["owner_id", "owner_type", "is_default"], name: "index_domains_on_owner_id_and_owner_type_and_is_default", using: :btree
  add_index "domains", ["owner_id", "owner_type"], name: "index_domains_on_owner_id_and_owner_type", using: :btree

  create_table "driven_signup_plugin_auths", force: :cascade do |t|
    t.integer  "environment_id"
    t.string   "name"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "driven_signup_plugin_auths", ["environment_id", "token"], name: "index_driven_signup_plugin_auths_on_environment_id_and_token", using: :btree
  add_index "driven_signup_plugin_auths", ["environment_id"], name: "index_driven_signup_plugin_auths_on_environment_id", using: :btree
  add_index "driven_signup_plugin_auths", ["token"], name: "index_driven_signup_plugin_auths_on_token", using: :btree

  create_table "email_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "template_type"
    t.string   "subject"
    t.text     "body"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "environment_notifications", force: :cascade do |t|
    t.text     "message"
    t.integer  "environment_id"
    t.string   "type"
    t.string   "title"
    t.boolean  "active"
    t.boolean  "display_only_in_homepage", default: false
    t.boolean  "display_to_all_users",     default: false
    t.boolean  "display_popup",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "environment_notifications_users", id: false, force: :cascade do |t|
    t.integer "environment_notification_id"
    t.integer "user_id"
  end

  add_index "environment_notifications_users", ["environment_notification_id"], name: "index_Zaem6uuw", using: :btree
  add_index "environment_notifications_users", ["user_id"], name: "index_ap3nohR9", using: :btree

  create_table "environments", force: :cascade do |t|
    t.string   "name"
    t.string   "contact_email"
    t.boolean  "is_default"
    t.text     "settings"
    t.text     "design_data"
    t.text     "custom_header"
    t.text     "custom_footer"
    t.string   "theme",                        default: "default",              null: false
    t.text     "terms_of_use_acceptance_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reports_lower_bound",          default: 0,                      null: false
    t.string   "redirection_after_login",      default: "keep_on_same_page"
    t.text     "signup_welcome_text"
    t.string   "languages"
    t.string   "default_language"
    t.string   "noreply_email"
    t.string   "redirection_after_signup",     default: "keep_on_same_page"
    t.string   "date_format",                  default: "month_name_with_year"
    t.text     "send_email_plugin_allow_to"
  end

  create_table "external_feeds", force: :cascade do |t|
    t.string   "feed_title"
    t.datetime "fetched_at"
    t.text     "address"
    t.integer  "blog_id",                      null: false
    t.boolean  "enabled",       default: true, null: false
    t.boolean  "only_once",     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "error_message"
    t.integer  "update_errors", default: 0
  end

  add_index "external_feeds", ["blog_id"], name: "index_external_feeds_on_blog_id", using: :btree
  add_index "external_feeds", ["enabled"], name: "index_external_feeds_on_enabled", using: :btree
  add_index "external_feeds", ["fetched_at"], name: "index_external_feeds_on_fetched_at", using: :btree

  create_table "favorite_enterprise_people", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "enterprise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_enterprise_people", ["enterprise_id"], name: "index_favorite_enterprise_people_on_enterprise_id", using: :btree
  add_index "favorite_enterprise_people", ["person_id", "enterprise_id"], name: "index_favorite_enterprise_people_on_person_id_and_enterprise_id", using: :btree
  add_index "favorite_enterprise_people", ["person_id"], name: "index_favorite_enterprise_people_on_person_id", using: :btree

  create_table "foo_plugin_bars", force: :cascade do |t|
    t.string "name"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.string   "group"
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["person_id", "friend_id"], name: "index_friendships_on_person_id_and_friend_id", using: :btree
  add_index "friendships", ["person_id"], name: "index_friendships_on_person_id", using: :btree

  create_table "gamification_plugin_badges", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.string   "description"
    t.text     "custom_fields"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "gamification_plugin_points_categorizations", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "point_type_id"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gamification_plugin_points_categorizations", ["point_type_id"], name: "index_points_categorizations_on_point_type_id", using: :btree
  add_index "gamification_plugin_points_categorizations", ["profile_id"], name: "index_gamification_plugin_points_categorizations_on_profile_id", using: :btree

  create_table "gamification_plugin_points_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gravatar_provider_plugin_user_email_hashes", force: :cascade do |t|
    t.integer "user_id"
    t.string  "email_md5_hash"
  end

  add_index "gravatar_provider_plugin_user_email_hashes", ["email_md5_hash"], name: "index_gravatar_provider_plugin_md5_hash", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer "parent_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.boolean "thumbnails_processed", default: false
    t.string  "label",                default: ""
  end

  add_index "images", ["parent_id"], name: "index_images_on_parent_id", using: :btree

  create_table "inputs", force: :cascade do |t|
    t.integer  "product_id",                                 null: false
    t.integer  "product_category_id",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.decimal  "price_per_unit"
    t.decimal  "amount_used"
    t.boolean  "relevant_to_price",          default: true
    t.boolean  "is_from_solidarity_economy", default: false
    t.integer  "unit_id"
  end

  add_index "inputs", ["product_category_id"], name: "index_inputs_on_product_category_id", using: :btree
  add_index "inputs", ["product_id"], name: "index_inputs_on_product_id", using: :btree

  create_table "licenses", force: :cascade do |t|
    t.string  "name",           null: false
    t.string  "slug",           null: false
    t.string  "url"
    t.integer "environment_id", null: false
  end

  create_table "mailing_sents", force: :cascade do |t|
    t.integer  "mailing_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailings", force: :cascade do |t|
    t.string   "type"
    t.string   "subject"
    t.text     "body"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "person_id"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mark_comment_as_read_plugin", force: :cascade do |t|
    t.integer "comment_id"
    t.integer "person_id"
  end

  add_index "mark_comment_as_read_plugin", ["comment_id", "person_id"], name: "index_mark_comment_as_read_plugin_on_comment_id_and_person_id", unique: true, using: :btree

  create_table "merit_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    default: false
    t.string   "target_model"
    t.integer  "target_id"
    t.text     "target_data"
    t.boolean  "processed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", force: :cascade do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: :cascade do |t|
    t.integer  "score_id"
    t.integer  "num_points", default: 0
    t.string   "log"
    t.datetime "created_at"
    t.integer  "action_id"
  end

  create_table "merit_scores", force: :cascade do |t|
    t.integer "sash_id"
    t.string  "category", default: "default"
  end

  create_table "national_region_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "national_regions", force: :cascade do |t|
    t.string   "name"
    t.string   "national_region_code"
    t.string   "parent_national_region_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "national_region_type_id"
  end

  add_index "national_regions", ["name"], name: "name_index", using: :btree
  add_index "national_regions", ["national_region_code"], name: "code_index", using: :btree

  create_table "newsletter_plugin_newsletters", force: :cascade do |t|
    t.integer "environment_id",                        null: false
    t.integer "person_id",                             null: false
    t.boolean "enabled",               default: false
    t.string  "subject"
    t.integer "periodicity",           default: 0
    t.integer "posts_per_blog",        default: 0
    t.integer "image_id"
    t.text    "footer"
    t.text    "blog_ids"
    t.text    "additional_recipients"
    t.boolean "moderated"
    t.text    "unsubscribers"
  end

  add_index "newsletter_plugin_newsletters", ["environment_id"], name: "index_newsletter_plugin_newsletters_on_environment_id", unique: true, using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "oauth_client_plugin_auths", force: :cascade do |t|
    t.integer  "provider_id"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "oauth_data"
    t.string   "type"
    t.string   "provider_user_id"
    t.text     "access_token"
    t.datetime "expires_at"
    t.text     "scope"
    t.text     "data",             default: "--- {}\n"
    t.integer  "profile_id"
  end

  add_index "oauth_client_plugin_auths", ["profile_id"], name: "index_oauth_client_plugin_auths_on_profile_id", using: :btree
  add_index "oauth_client_plugin_auths", ["provider_id"], name: "index_oauth_client_plugin_auths_on_provider_id", using: :btree
  add_index "oauth_client_plugin_auths", ["provider_user_id"], name: "index_oauth_client_plugin_auths_on_provider_user_id", using: :btree
  add_index "oauth_client_plugin_auths", ["type"], name: "index_oauth_client_plugin_auths_on_type", using: :btree

  create_table "oauth_client_plugin_providers", force: :cascade do |t|
    t.integer  "environment_id"
    t.string   "strategy"
    t.string   "name"
    t.text     "options"
    t.boolean  "enabled"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "client_id"
    t.text     "client_secret"
  end

  add_index "oauth_client_plugin_providers", ["client_id"], name: "index_oauth_client_plugin_providers_on_client_id", using: :btree

  create_table "organization_ratings", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "person_id"
    t.integer  "comment_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_ratings_configs", force: :cascade do |t|
    t.integer "environment_id"
    t.integer "cooldown",       default: 24
    t.integer "integer",        default: 10
    t.integer "default_rating", default: 1
    t.string  "order",          default: "recent"
    t.string  "string",         default: "recent"
    t.integer "per_page",       default: 10
    t.boolean "vote_once",      default: false
    t.boolean "boolean",        default: true
    t.boolean "are_moderated",  default: true
  end

  create_table "price_details", force: :cascade do |t|
    t.decimal  "price",              default: 0.0
    t.integer  "product_id"
    t.integer  "production_cost_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_qualifiers", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "qualifier_id"
    t.integer  "certifier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_qualifiers", ["certifier_id"], name: "index_product_qualifiers_on_certifier_id", using: :btree
  add_index "product_qualifiers", ["product_id"], name: "index_product_qualifiers_on_product_id", using: :btree
  add_index "product_qualifiers", ["qualifier_id"], name: "index_product_qualifiers_on_qualifier_id", using: :btree

  create_table "production_costs", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "product_category_id"
    t.string   "name"
    t.decimal  "price"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "discount"
    t.boolean  "available",           default: true
    t.boolean  "highlighted",         default: false
    t.integer  "unit_id"
    t.integer  "image_id"
    t.string   "type"
    t.text     "data"
    t.boolean  "archived",            default: false
  end

  add_index "products", ["created_at"], name: "index_products_on_created_at", using: :btree
  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id", using: :btree
  add_index "products", ["profile_id"], name: "index_products_on_profile_id", using: :btree

  create_table "profile_activities", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "activity_id"
    t.string   "activity_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "profile_activities", ["activity_id", "activity_type"], name: "index_profile_activities_on_activity_id_and_activity_type", using: :btree
  add_index "profile_activities", ["activity_type"], name: "index_profile_activities_on_activity_type", using: :btree
  add_index "profile_activities", ["profile_id"], name: "index_profile_activities_on_profile_id", using: :btree

  create_table "profile_suggestions", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "suggestion_id"
    t.string   "suggestion_type"
    t.text     "categories"
    t.boolean  "enabled",         default: true
    t.float    "score",           default: 0.0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "profile_suggestions", ["person_id"], name: "index_profile_suggestions_on_person_id", using: :btree
  add_index "profile_suggestions", ["score"], name: "index_profile_suggestions_on_score", using: :btree
  add_index "profile_suggestions", ["suggestion_id"], name: "index_profile_suggestions_on_suggestion_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.string   "identifier"
    t.integer  "environment_id"
    t.boolean  "active",                             default: true
    t.string   "address"
    t.string   "contact_phone"
    t.integer  "home_page_id"
    t.integer  "user_id"
    t.integer  "region_id"
    t.text     "data"
    t.datetime "created_at"
    t.float    "lat"
    t.float    "lng"
    t.integer  "geocode_precision"
    t.boolean  "enabled",                            default: true
    t.string   "nickname",                limit: 16
    t.text     "custom_header"
    t.text     "custom_footer"
    t.string   "theme"
    t.boolean  "public_profile",                     default: true
    t.date     "birth_date"
    t.integer  "preferred_domain_id"
    t.datetime "updated_at"
    t.boolean  "visible",                            default: true
    t.integer  "image_id"
    t.boolean  "validated",                          default: true
    t.string   "cnpj"
    t.string   "national_region_code"
    t.boolean  "is_template",                        default: false
    t.integer  "template_id"
    t.string   "redirection_after_login"
    t.integer  "friends_count",                      default: 0,     null: false
    t.integer  "members_count",                      default: 0,     null: false
    t.integer  "activities_count",                   default: 0,     null: false
    t.string   "personal_website"
    t.string   "jabber_id"
    t.integer  "welcome_page_id"
    t.boolean  "allow_members_to_invite",            default: true
    t.boolean  "invite_friends_only",                default: false
    t.boolean  "secret",                             default: false
    t.integer  "bar_id"
    t.integer  "comments_count"
    t.integer  "sash_id"
    t.integer  "level",                              default: 0
  end

  add_index "profiles", ["activities_count"], name: "index_profiles_on_activities_count", using: :btree
  add_index "profiles", ["created_at"], name: "index_profiles_on_created_at", using: :btree
  add_index "profiles", ["environment_id"], name: "index_profiles_on_environment_id", using: :btree
  add_index "profiles", ["friends_count"], name: "index_profiles_on_friends_count", using: :btree
  add_index "profiles", ["identifier"], name: "index_profiles_on_identifier", using: :btree
  add_index "profiles", ["members_count"], name: "index_profiles_on_members_count", using: :btree
  add_index "profiles", ["region_id"], name: "index_profiles_on_region_id", using: :btree
  add_index "profiles", ["user_id", "type"], name: "index_profiles_on_user_id_and_type", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "proposals_discussion_plugin_proposal_evaluations", force: :cascade do |t|
    t.integer  "proposal_task_id"
    t.integer  "evaluator_id"
    t.integer  "flagged_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposals_discussion_plugin_proposal_evaluations", ["evaluator_id"], name: "index_proposals_discussion_plugin_proposal_evaluator_id", using: :btree
  add_index "proposals_discussion_plugin_proposal_evaluations", ["proposal_task_id"], name: "index_proposals_discussion_plugin_proposal_task_id", using: :btree

  create_table "proposals_discussion_plugin_ranking_items", force: :cascade do |t|
    t.integer  "position"
    t.string   "abstract"
    t.integer  "votes_for"
    t.integer  "votes_against"
    t.integer  "hits"
    t.decimal  "effective_support"
    t.integer  "proposal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposals_discussion_plugin_ranking_items", ["proposal_id"], name: "index_proposals_discussion_plugin_ranking_proposal_id", using: :btree

  create_table "proposals_discussion_plugin_task_categories", id: false, force: :cascade do |t|
    t.integer "task_id"
    t.integer "category_id"
  end

  add_index "proposals_discussion_plugin_task_categories", ["category_id"], name: "proposals_discussion_plugin_tc_cat_index", using: :btree
  add_index "proposals_discussion_plugin_task_categories", ["task_id"], name: "proposals_discussion_plugin_tc_task_index", using: :btree

  create_table "qualifier_certifiers", force: :cascade do |t|
    t.integer "qualifier_id"
    t.integer "certifier_id"
  end

  create_table "qualifiers", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refused_join_community", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "community_id"
  end

  create_table "region_validators", id: false, force: :cascade do |t|
    t.integer "region_id"
    t.integer "organization_id"
  end

  create_table "reported_images", force: :cascade do |t|
    t.integer "size"
    t.string  "content_type"
    t.string  "filename"
    t.integer "height"
    t.integer "width"
    t.integer "abuse_report_id"
  end

  create_table "role_assignments", force: :cascade do |t|
    t.integer "accessor_id",   null: false
    t.string  "accessor_type"
    t.integer "resource_id"
    t.string  "resource_type"
    t.integer "role_id",       null: false
    t.boolean "is_global"
  end

  create_table "roles", force: :cascade do |t|
    t.string  "name"
    t.string  "key"
    t.boolean "system",         default: false
    t.text    "permissions"
    t.integer "environment_id"
    t.integer "profile_id"
  end

  create_table "sashes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scraps", force: :cascade do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "scrap_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "context_id"
  end

  create_table "search_term_occurrences", force: :cascade do |t|
    t.integer  "search_term_id"
    t.datetime "created_at"
    t.integer  "total",          default: 0
    t.integer  "indexed",        default: 0
  end

  add_index "search_term_occurrences", ["created_at"], name: "index_search_term_occurrences_on_created_at", using: :btree

  create_table "search_terms", force: :cascade do |t|
    t.string  "term"
    t.integer "context_id"
    t.string  "context_type"
    t.string  "asset",            default: "all"
    t.float   "score",            default: 0.0
    t.float   "relevance_score",  default: 0.0
    t.float   "occurrence_score", default: 0.0
  end

  add_index "search_terms", ["asset"], name: "index_search_terms_on_asset", using: :btree
  add_index "search_terms", ["occurrence_score"], name: "index_search_terms_on_occurrence_score", using: :btree
  add_index "search_terms", ["relevance_score"], name: "index_search_terms_on_relevance_score", using: :btree
  add_index "search_terms", ["score"], name: "index_search_terms_on_score", using: :btree
  add_index "search_terms", ["term"], name: "index_search_terms_on_term", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "sniffer_plugin_opportunities", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "opportunity_id"
    t.string   "opportunity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sniffer_plugin_profiles", force: :cascade do |t|
    t.integer  "profile_id"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_organizations_plugin_approve_paternity_relations", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "child_id"
    t.string   "child_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_organizations_plugin_relations", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "child_id"
    t.string   "child_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suggestion_connections", force: :cascade do |t|
    t.integer "suggestion_id",   null: false
    t.integer "connection_id",   null: false
    t.string  "connection_type", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "parent_id"
    t.boolean "pending",        default: false
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree
  add_index "tags", ["parent_id"], name: "index_tags_on_parent_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.text     "data"
    t.integer  "status"
    t.datetime "end_date"
    t.integer  "requestor_id"
    t.integer  "target_id"
    t.string   "code",           limit: 40
    t.string   "type"
    t.datetime "created_at"
    t.string   "target_type"
    t.integer  "image_id"
    t.boolean  "spam",                      default: false
    t.integer  "responsible_id"
    t.integer  "closed_by_id"
  end

  add_index "tasks", ["requestor_id"], name: "index_tasks_on_requestor_id", using: :btree
  add_index "tasks", ["spam"], name: "index_tasks_on_spam", using: :btree
  add_index "tasks", ["status"], name: "index_tasks_on_status", using: :btree
  add_index "tasks", ["target_id", "target_type"], name: "index_tasks_on_target_id_and_target_type", using: :btree
  add_index "tasks", ["target_id"], name: "index_tasks_on_target_id", using: :btree
  add_index "tasks", ["target_type"], name: "index_tasks_on_target_type", using: :btree

  create_table "terms_forum_people", id: false, force: :cascade do |t|
    t.integer "forum_id"
    t.integer "person_id"
  end

  add_index "terms_forum_people", ["forum_id", "person_id"], name: "index_terms_forum_people_on_forum_id_and_person_id", using: :btree

  create_table "thumbnails", force: :cascade do |t|
    t.integer "size"
    t.string  "content_type"
    t.string  "filename"
    t.integer "height"
    t.integer "width"
    t.integer "parent_id"
    t.string  "thumbnail"
  end

  add_index "thumbnails", ["parent_id"], name: "index_thumbnails_on_parent_id", using: :btree

  create_table "tolerance_time_plugin_publications", force: :cascade do |t|
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolerance_time_plugin_tolerances", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "content_tolerance"
    t.integer  "comment_tolerance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: :cascade do |t|
    t.string  "singular",       null: false
    t.string  "plural",         null: false
    t.integer "position"
    t.integer "environment_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",           limit: 40
    t.string   "salt",                       limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.text     "terms_of_use"
    t.string   "terms_accepted",             limit: 1
    t.integer  "environment_id"
    t.string   "password_type"
    t.boolean  "enable_email",                          default: false
    t.string   "last_chat_status",                      default: ""
    t.string   "chat_status",                           default: ""
    t.datetime "chat_status_at"
    t.string   "activation_code",            limit: 40
    t.datetime "activated_at"
    t.string   "return_to"
    t.datetime "last_login_at"
    t.string   "private_token"
    t.datetime "private_token_generated_at"
  end

  create_table "validation_infos", force: :cascade do |t|
    t.text    "validation_methodology"
    t.text    "restrictions"
    t.integer "organization_id"
  end

  create_table "virtuoso_plugin_custom_queries", force: :cascade do |t|
    t.integer  "environment_id",                null: false
    t.string   "name"
    t.text     "query"
    t.text     "template"
    t.text     "stylesheet"
    t.boolean  "enabled",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "volunteers_plugin_assignments", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "period_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "volunteers_plugin_assignments", ["period_id"], name: "index_volunteers_plugin_assignments_on_period_id", using: :btree
  add_index "volunteers_plugin_assignments", ["profile_id", "period_id"], name: "index_volunteers_plugin_assignments_on_profile_id_and_period_id", using: :btree
  add_index "volunteers_plugin_assignments", ["profile_id"], name: "index_volunteers_plugin_assignments_on_profile_id", using: :btree

  create_table "volunteers_plugin_periods", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.text     "name"
    t.datetime "start"
    t.datetime "end"
    t.integer  "minimum_assigments"
    t.integer  "maximum_assigments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "volunteers_plugin_periods", ["owner_id", "owner_type"], name: "index_volunteers_plugin_periods_on_owner_id_and_owner_type", using: :btree
  add_index "volunteers_plugin_periods", ["owner_type"], name: "index_volunteers_plugin_periods_on_owner_type", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "vote",          null: false
    t.integer  "voteable_id",   null: false
    t.string   "voteable_type", null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "fk_voteables", using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "fk_voters", using: :btree

end
