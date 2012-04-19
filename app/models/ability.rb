class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    if user.admin?
      can :manage, Cms::User
      
      #controller action abilities
      can :manage, RealEstate
      cannot :edit, RealEstate, :state => 'published'
      cannot :destroy, RealEstate, :state => 'published'
      can :manage, [Address,Information,Pricing,Infrastructure,Figure,AdditionalDescription,MediaAsset]
      cannot :manage, [Address,Information,Pricing,Infrastructure,Figure,AdditionalDescription,MediaAsset], :real_estate=>{:state => 'published'}

      can :manage, NewsItem

      #real estate state machine abilities, order matters, do not put before controller action abilities
      can :reject_it, RealEstate
      can :publish_it, RealEstate
      can :unpublish_it, RealEstate
      cannot :review_it, RealEstate
    end
    
    if user.editor?
      # state machine abilities
      can :review_it, RealEstate

      #controller action abilities
      can :update, RealEstate, :state => 'editing' #do not use :manage, this will break state machine cans
      can :destroy, RealEstate, :state => 'editing'
      can :manage, [Address,Information,Pricing,Infrastructure,Figure,AdditionalDescription,MediaAsset], :real_estate=>{:state => 'editing'}
      cannot :manage, [Address,Information,Pricing,Infrastructure,Figure,AdditionalDescription,MediaAsset], :real_estate=>{:state => ['in_review', 'published']}

      cannot :manage, NewsItem
    end

  end
end
