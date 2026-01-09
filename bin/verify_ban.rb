# bin/verify_ban.rb

# NOTE: This script is intended to be run with `rails runner` to verify the banning logic.
# Usage: rails runner bin/verify_ban.rb

begin
  puts "=== Starting Ban Logic Verification ==="

  # 1. Setup
  puts "Setting up test data..."

  # Create a member to be banned
  member = Member.find_or_create_by!(email: "banned_test@example.com") do |m|
    m.name = "Banned Test User"
    m.password = "password"
    m.sex = 1
    m.birthday = Date.new(1990, 1, 1)
  end
  member.update!(is_banned: false) # Ensure fresh start

  # Create a target member
  target = Member.find_or_create_by!(email: "target_test@example.com") do |m|
    m.name = "Target User"
    m.password = "password"
    m.sex = 2
    m.birthday = Date.new(1995, 5, 5)
    m.special_member = true
    m.price_per_hour = 1000
    m.free_candidates = ["月:10", "月:11", "月:12"] # Add some availability
  end

  # Create a reservation
  reservation = Reservation.create!(
    member: member,
    target_member: target,
    start_at: 1.week.from_now.change(hour: 10, min: 0, sec: 0),
    hours: 2,
    status: :approved
  )
  puts "Created reservation: #{reservation.id} (Status: #{reservation.status})"

  # 2. Execute Ban
  puts "Banning member..."
  member.ban!

  # 3. Verify Ban Effects on Member
  member.reload
  if member.is_banned?
    puts "PASS: Member is banned."
  else
    puts "FAIL: Member is NOT banned."
  end

  # 4. Verify Effects on Existing Reservations
  reservation.reload
  if reservation.status == "rejected"
    puts "PASS: Existing reservation was rejected."
  else
    puts "FAIL: Existing reservation status is #{reservation.status} (expected rejected)."
  end

  # 5. Verify Prevention of New Reservations
  puts "Attempting to create new reservation for banned member..."
  new_res = Reservation.new(
    member: member,
    target_member: target,
    start_at: 1.week.from_now.change(hour: 12, min: 0, sec: 0),
    hours: 1
  )

  if !new_res.valid? && new_res.errors[:base].include?("利用停止されています")
    puts "PASS: New reservation blocked with correct error."
  else
    puts "FAIL: New reservation valid? #{new_res.valid?}. Errors: #{new_res.errors.full_messages}"
  end

  # 6. Verify Search Scope
  puts "Verifying search scope..."
  found_in_active = Member.active.exists?(member.id)
  if !found_in_active
    puts "PASS: Banned member not found in Member.active scope."
  else
    puts "FAIL: Banned member still found in Member.active scope."
  end

  puts "=== Verification Complete ==="
rescue => e
  puts "ERROR during verification: #{e.message}"
  puts e.backtrace
end
