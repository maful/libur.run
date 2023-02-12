# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root "home#index"
  resources :installation, only: :index do
    collection do
      post "license"
      post "personal"
      post "company"
      post "complete"
    end
  end
  get "invitation/accept", to: "invitation#edit"
  patch "invitation/accept", to: "invitation#update"

  get "/404", to: "errors#not_found"

  scope module: "dashboard" do
    get "home", to: "home#index"
    get "calendar", to: "calendar#index"
    resources :users, except: :destroy, param: :public_id do
      member do
        patch "resend_invitation"
        patch "update_status"
      end
    end
    resources :leaves, except: :destroy, param: :public_id do
      patch "cancel", on: :member
      get "summary", on: :collection
    end
    resources :team_leaves, only: [:index, :show, :edit, :update], param: :public_id, path: "team-leaves"
    resources :claims, only: [:index, :show, :new, :create], param: :public_id do
      post "validate_claim", on: :collection
      patch "cancel", on: :member
    end
    resources :team_claims, only: [:index, :show, :edit, :update], param: :public_id, path: "team-claims"
    resources :reports, only: :index

    namespace :settings do
      # set redirection status to temporarily, further changes in the URI might be made in the future.
      root to: redirect("/settings/profile", status: 302)
      resource :my_profile, controller: "my_profile", path: "profile", only: :show
      resource :me, controller: "me", only: [:show, :update]
      resource :company, controller: "company", only: [:show, :update]
      resources :leave_types, except: [:show, :destroy], param: :public_id
      resources :claim_types, except: [:show, :destroy], param: :public_id
      resource :password, controller: "password", only: [:show, :update]
      resource :notifications, only: :show
    end
  end
end
