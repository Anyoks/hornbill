class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :role
  before_create :set_default_role

 
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
