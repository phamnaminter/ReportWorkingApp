module UsersHelper
  def gravatar_for object, width = Settings.user.small_avatar_width,
    height = Settings.user.small_avatar_height
    if object.avatar.attached?
      return image_tag(object.display_avatar, class: "gravatar",
        width: width, height: height)
    end

    gravatar_url = Settings.gravatar.avatar_default_url
    image_tag(gravatar_url, class: "gravatar",
        width: width, height: height)
  end
end
