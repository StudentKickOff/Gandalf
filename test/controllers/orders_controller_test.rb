require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    stub_request(:get, "http://fkgent.be/api_isengard_v2.php").
      with(query: hash_including(u: "")).to_return(body: 'FAIL')

    sign_in users(:tom)
  end

  test "uploading partially failed orders" do

    # Quick check for the used fixture
    three = orders(:three)
    assert_equal 0, three.paid

    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      # Posting the csv file
      post :upload, {
        event_id: 1,
        separator: ';',
        amount_column: 'Amount',
        csv_file: fixture_file_upload('files/unsuccesful_registration_payments.csv') }
    end

    # Check if the correct rows failed.
    assert_not_nil assigns(:csvfails)
    assigns(:csvfails).each do |csvfail|
      assert_match(/FAIL.*/, csvfail.to_s)
    end

    # Check if the flash is correct
    assert_equal 'Updated 1 payment successfully.', flash[:success]
    assert_equal 'The rows listed below contained an invalid code, please fix them by hand.', flash[:error]

    # Check if the success registration got changed.
    assert_equal 0.01, three.reload.paid

  end

  test "resend actuallly sends an email" do
    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      xhr :get, :resend, event_id: events(:codenight), id: orders(:one).id
    end
  end

  test "resend sends payment email when !is_paid" do
    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      xhr :get, :resend, event_id: events(:codenight), id: orders(:three).id
    end

    email = ActionMailer::Base.deliveries.last
    assert_match(/Registration for/, email.subject)
  end

  test "resend sends ticket email when is_paid" do
    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      xhr :get, :resend, event_id: events(:codenight), id: orders(:one).id
    end

    email = ActionMailer::Base.deliveries.last
    assert_match(/Ticket for/, email.subject)
  end

  test "manual full paying works" do
    three = orders(:three)
    four = orders(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    [three, four].each do |order|
      assert_difference "ActionMailer::Base.deliveries.size", +1 do
        xhr :put, :update, {
          event_id: order.event.id,
          id: order.id,
          order: { to_pay: 0 }
        }, remote: true
      end
      assert_equal order.price, order.reload.paid
      email = ActionMailer::Base.deliveries.last
      assert_match(/Ticket for/, email.subject)
    end

  end

  test "manual partial paying works" do
    three = orders(:three)
    four = orders(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    to_pay = 0.01

    [three, four].each do |registration|
      assert_difference "ActionMailer::Base.deliveries.size", +1 do
        xhr :put, :update, {
          event_id: order.event.id,
          id: order.id,
          registration: { to_pay: to_pay }
        }, remote: true
      end
      assert order.price > order.reload.paid
      email = ActionMailer::Base.deliveries.last
      assert_match(/Order for/, email.subject)
    end

  end

  test "manual overpaying works" do
    three = orders(:three)
    four = orders(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    to_pay = -5

    [three, four].each do |registration|
      assert_difference "ActionMailer::Base.deliveries.size", +2 do
        xhr :put, :update, {
          event_id: order.event.id,
          id: order.id,
          registration: { to_pay: to_pay }
        }, remote: true
      end
      assert order.price < order.reload.paid

      email = ActionMailer::Base.deliveries[-2]
      assert_match(/Ticket for/, email.subject)

      email = ActionMailer::Base.deliveries[-1]
      assert_match(/Overpayment for/, email.subject)
    end

  end


  test "manual not changing mails nor changes the code" do
    three = orders(:three)
    four = orders(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    [three, four].each do |registration|
      paid, code = order.paid, order.payment_code
      assert_no_difference "ActionMailer::Base.deliveries.size" do
        xhr :put, :update, {
          event_id: order.event.id,
          id: order.id,
          order: { to_pay: order.to_pay }
        }, remote: true
      end
      assert_equal paid, order.reload.paid
      assert_equal code, order.reload.payment_code
    end
  end

  test "admins can manage registrations from other events" do
    user = users(:adminfelix)
    ability = Ability.new(user)

    r = order(:two)
    assert ability.can?(:manage, r)
  end

end