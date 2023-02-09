# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admins = User.create([ { email: "alex@cybersuperpowers.com", username: "alex", password: "puppybowl2014", role: "admin" },
                       { email: "vladin@cybersuperpowers.com", username: "admin", password: "adminadmin", role: "admin" }
                    ])

puppies = Puppy.create([ {name: "miss martian", pic: "pets/miss_martian.png"},
                         {name: "august", pic: "pets/august.png"},
                         {name: "bach", pic: "pets/bach.png"},
                         {name: "delachaise", pic: "pets/delachaise.png"},
                         {name: "ginger", pic: "pets/ginger.png"},
                         {name: "laney", pic: "pets/laney.png"},
                         {name: "loren", pic: "pets/loren.png"},
                         {name: "poppy", pic: "pets/poppy.png"},
                         {name: "shyla", pic: "pets/shyla.png"},
                         {name: "sparky", pic: "pets/sparky.png"},
                         {name: "van helsig", pic: "pets/van_helsig.png"},
                         {name: "mandy", pic: "pets/mandy.png"}
                      ])
