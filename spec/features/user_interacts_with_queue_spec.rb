require "spec_helper"
require "rails_helper"

feature "User navigates to the video details" do
  scenario "add and reorders videos in the queue", :vcr do
    comedies = Fabricate(:category)
    matrix = Fabricate(:video, title: "Matrix", category: comedies)
    braveheart = Fabricate(:video, title: "Braveheart", category: comedies)
    spiderman = Fabricate(:video, title: "Spiderman", category: comedies)

    log_in
    find("a[href='/videos/#{matrix.id}']").click
    expect(page).to have_content(matrix.title)

    click_button "+ My Queue"
    expect(page).to have_content(matrix.title)

    visit video_path(matrix)
    expect(page).not_to have_button("+ My Queue")

    visit root_path
    find("a[href='/videos/#{braveheart.id}']").click
    click_button "+ My Queue"

    visit root_path
    find("a[href='/videos/#{spiderman.id}']").click
    click_button "+ My Queue"

    find("input[data-video-id='#{braveheart.id}']").set(1)
    find("input[data-video-id='#{spiderman.id}']").set(2)
    find("input[data-video-id='#{matrix.id}']").set(3)

    click_button "Update Instant Queue"

    expect(find("input[data-video-id='#{braveheart.id}']").value).to eq("1")
    expect(find("input[data-video-id='#{spiderman.id}']").value).to eq("2")
    expect(find("input[data-video-id='#{matrix.id}']").value).to eq("3")
  end
end
