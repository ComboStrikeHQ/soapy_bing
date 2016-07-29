# frozen_string_literal: true
RSpec.describe SoapyBing::Ads do
  let(:campaign_id) { 91834220 }
  let(:ad_group_id) { 4464286758 }
  let(:fixture_payload) { JSON.load(File.read(File.join('spec', 'fixtures', fixture_file))) }

  subject(:instance) { described_class.new }

  describe '#get_ad_groups_by_campaign_id', :vcr do
    let(:fixture_file) { 'get_ad_groups_by_campaign_id.json' }

    subject { instance.get_ad_groups_by_campaign_id(campaign_id) }

    it { expect(subject).to eq(fixture_payload) }
  end

  describe '#get_ads_by_ad_group_id', :vcr do
    let(:fixture_file) { 'get_ads_by_ad_group_id.json' }

    subject { instance.get_ads_by_ad_group_id(ad_group_id) }

    it { expect(subject).to eq(fixture_payload) }
  end

  describe '#get_targets_by_campaign_ids', :vcr do
    let(:fixture_file) { 'get_targets_by_campaign_ids.json' }

    subject { instance.get_targets_by_campaign_ids([campaign_id]) }

    it { expect(subject).to eq(fixture_payload) }
  end
end
