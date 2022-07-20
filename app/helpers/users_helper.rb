module UsersHelper
  def gravatar_for user, size: Settings.gravatar.default_size
    if user.avatar.attached?
      return image_tag(user.display_avatar, alt: user.full_name, class:
                      "gravatar")
    end

    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "#{Settings.gravatar.url}#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.full_name, class: "gravatar")
  end
end
