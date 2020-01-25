Rails.application.routes.draw do
  constraints format: :json do
    namespace :api do
      resources :net_promoter_scores, only: %i[create index]
    end
  end
end
