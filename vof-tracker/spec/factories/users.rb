FactoryGirl.define do
  factory :user do
    skip_create

    user_info do
      {
        id: "-KXGy1MU1oimjQgFimCR",
        email: "rehema.wachira@andela.com",
        first_name: "Rehema",
        last_name: "Wachira",
        name: "Rehema Wachira",
        picture: "",
        roles: {
          Fellow: "-KXGy1EB1oimjQgFim6C"
        },
        permissions: {
          "TRACK_VOF" => "-KXGy1EB1oimjQgFim6C",
          "MANAGE_VOF" => "-KXGy1MU1oimjQgFimCR"
        },
        exp: 1_486_630_160
      }
    end
  end
end
