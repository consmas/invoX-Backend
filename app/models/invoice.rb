class Invoice < ApplicationRecord
  belongs_to :programme
  belongs_to :supplier, class_name: "User", optional: true
end
