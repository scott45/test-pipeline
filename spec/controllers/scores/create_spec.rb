# require "rails_helper"

# RSpec.describe ScoresController, type: :controller do
#   let(:user) { create :user }
#   let(:bootcamper) { create :bootcamper }
#   let(:phase) { create :phase }
#   let!(:framework_criterium) { create :framework_criterium }
#   let!(:assessments) do
#     create :assessment,
#            name: "Writing professionally",
#            phases: [phase],
#            framework_criterium_id: framework_criterium.id,
#            context: "Medium Post",
#            description: "Simple description"
#   end

#   let!(:score) { create :score, camper_id: bootcamper.camper_id }
#   before do
#     request.headers["accept"] = "application/javascript"
#     stub_current_user :user
#   end

#   # describe "POST #create" do
#   #   context "when an admin user scores a camper" do
#   #     it "saves successfully" do
#   #       allow(controller).to receive_message_chain(
#   #         "helpers.admin?"
#   #       ).and_return true

#   #       stub_camper_progress(true)
#   #       post :create, params: { scores: [{ score: 2,
#   #                                          comments: "good",
#   #                                          assessment_id: assessments.id,
#   #                                          phase_id: phase.id }],
#   #                               id: bootcamper.id }
#   #       expect(flash[:notice]).to eq "score-success"
#   #     end
#   #   end

#     context "when the lfa scores a camper" do
#       it "saves successfully" do
#         allow(controller).to receive_message_chain(
#           "helpers.user_is_lfa?"
#         ).and_return true

#         allow(controller).to receive_message_chain(
#           "helpers.admin?"
#         ).and_return false

#         stub_camper_progress(true)
#         post :create, params: { scores: [{ score: 3,
#                                            comments: "excellent job",
#                                            assessment_id: assessments.id,
#                                            phase_id: phase.id }],
#                                 id: bootcamper.id }
#         expect(flash[:notice]).to eq "score-success"
#       end
#     end

#     # context "when score is not passed" do
#     #   it "doesn't save successfully" do
#     #     allow(controller).to receive_message_chain(
#     #       "helpers.admin?",
#     #       "helpers.user_is_lfa?"
#     #     ).and_return false

#     #     post :create, params: { scores: [],
#     #                             id: bootcamper.id }
#     #     expect(flash[:notice]).not_to eq "score-success"
#     #   end
#     # end

#     context "when user who is not the lfa or admin scores a camper" do
#       it "doesn't save score for the camper" do
#         allow(controller).to receive_message_chain(
#           "helpers.admin?",
#           "helpers.user_is_lfa?"
#         ).and_return false

#         post :create, params: { scores: [{ score: 1,
#                                            comments: "Below expectation",
#                                            assessment_id: assessments.id,
#                                            phase_id: phase.id }],
#                                 id: bootcamper.id }
#         expect(response.body).to eq ""
#       end
#     end
#   end
# end
