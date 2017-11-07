Rails.application.routes.draw do
  
    root to: "index#index", as: "index"
    get "/login" => "sessions#login"
    get "/logout" => "sessions#logout"
  
    scope "/bootcampers", as: "bootcampers" do
      get "/" => "bootcampers#index"
      get "/all" => "bootcampers#all"
      get "/:id/scores" => "scores#new"
      post "/:id/scores/new" => "scores#create", as: "save_scores"
      put "/:id" => "bootcampers#update"
      post "/add" => "bootcampers#add"
      get "/edit" => "bootcampers#edit"
      get "/:id/phases/" => "phases#program_phases"
      get "/:id/completed_assessments" => "assessments#get_completed_assessments"
      get "/:id/phases/:phase_id/assessments" => "assessments#all"
      put "/:id/decision_comments" => "bootcampers#save_decision_comments"
      get "/:id/decision_comments" => "bootcampers#get_decision_comments"
      put "/:id/decision_reasons" => "bootcampers#save_decision_reasons"
      get "/:id/decision/:status/reasons/:stage" => "decision_reason#get_status_reasons"
    end
  
    get "content_management" => "content_management#index"
    get "support" => "support#index"
  
    get "learner" => "learners#index"
    get "learning_outcomes" => "learners#learning_outcomes"
    get "faqs" => "learners#faqs"
  
    resources :criteria
    
    get "output/details" => "assessments#get_framework_criteria"

    resources :assessments
    
    get "/assessment/:id" => "assessments#get_assessment_metrics"

    get "/framework/:id/criteria" => "criteria#get_criteria"

    get "/framework-criteria/:framework_id/:criterium_id" => "criteria#get_framework_criterium_id"
  
    get "search/autocomplete" => "search#autocomplete"
  
    match "/(*url)", to: "no_access#index", via: :all
  
  end
