class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:twitter]
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  belongs_to :role
  before_create :set_default_role
  has_many :authentications, dependent: :destroy

  extend FriendlyId
    friendly_id :full_names, use: :slugged


  #******************Omniauth********************#
  # def self.from_omniauth(auth, provider_type)
  #   self.email = auth[:info][:email] if self.email.blank?
  #   case provider_type
  #     when :twitter
  #       name = auth[:info][:name].split(' ')
  #       self.first_name ||= name[0]
  #       self.last_name ||= name[1]
  #       self.avatar = auth.info.image

  #   # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #   #   user.email = auth.info.email
  #   #   byebug
  #   #   user.password = Devise.friendly_token[0,20]
  #   #   user.first_name = auth.info.name   # assuming the user model has a name
  #   #   user.avatar = auth.info.image # assuming the user model has an image
  #   end
  # end

  def update_from_oauth(auth, provider_type)
    self.email = auth[:info][:email] if self.email.blank?
    case provider_type
    when :twitter
      name = auth[:info][:name].split(' ')
      self.first_name ||= name[0]
      self.last_name ||= name[1]
      # self.remote_avatar_url = auth[:extra][:raw_info][:profile_image_url]
      self.avatar = auth.info.image

    # when :facebook
    #   ...
    # when :google
    #   ...
    end
  end
  #********************End************************#

 
#*******************User Admin Methods************#

  def is_admin?
  	if self.role.nil?
  		false
  	elsif self.role.name == "admin"
  		true
  	else
  		false
  	end
  end

  def full_names
  	first = self.first_name
  	last = self.last_name
  	 "#{first} #{last}"
  end

  def is_moderator?
  	if self.role.nil?
  		false
  	elsif self.role.name == "moderator"
  		true
  	else
  		false
  	end
  end

  def has_admin_previlages?
  	if is_admin? || is_moderator?
  		true
  	else
  		false
  	end
  end

  def make_moderator
  	self.update_attributes :role_id => 3
  	# self.role ||= Role.find_by_name('moderator') 
  end

  def make_admin
  	self.update_attributes :role_id => 4
  end

  def make_normal_user
  	self.update_attributes :role_id => 1
  end

  def show_admins
  	User.where(:role_id => 4 )
  end
#*******************End of User Admin Methods************#

	private
	
	def set_default_role
		self.role ||= Role.find_by_name('registered') 
	end
end
