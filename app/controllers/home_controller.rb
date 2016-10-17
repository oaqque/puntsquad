class HomeController < ApplicationController

  def index
    #Locate Today's Bets
    @today_bets = Bet.where("resolved = ? AND sport != ?", false, 7).order("date_of_bet ASC").order("sport ASC").order("game ASC")
    @today_horse_bets = Bet.where("resolved = ? AND sport = ?", false, 7).order("date_of_bet ASC").order("sport ASC").order("game ASC")

    #Target This Month's Bets
    @bets_by_year = Bet.where("EXTRACT(YEAR FROM date_of_bet) = ?", Time.now.year)
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM date_of_bet) = ?", Time.now.month)
    @bets_by_month = @bets_by_month.order("date_of_bet DESC")


    #Monthly Total
    @monthly_total = 0
    @bets_by_month.each do |x|
      if x.profit_or_loss > -100 && x.profit_or_loss < 100
        @monthly_total += x.profit_or_loss
      end
    end

  end

  def betting_guide
  end

  def analysis
    #Grab all the bets
    @bets = Bet.all
    @sum = 0

    #Separate the bets into odds less than 3
    #Separate the bets into odds between 3 and 7
    #Separate the bets into odds larger than 7
    @horse_under_3 = @bets.where("sport = ? AND odds < ?", 7, 3)
    @horse_between_3_and_7 = @bets.where("sport = ? AND odds <= ? AND odds >= ?", 7, 7, 3)
    @horse_over_7 = @bets.where("sport = ? AND odds > ?", 7, 7)

    #Find total staked on odds less than 3
    #Find PnL for odds less than 3
    @hu3_total_staked = 0
    @hu3_pnl = 0
    for bet in @horse_under_3
      @hu3_total_staked += bet.units_placed
      @hu3_pnl += bet.profit_or_loss
    end

    #Find total staked on odds between 3 and 7
    #Find PnL for odds between 3 and 7
    @h3to7_total_staked = 0
    @h3to7_pnl = 0
    for bet in @horse_between_3_and_7
      @h3to7_total_staked += bet.units_placed
      @h3to7_pnl += bet.profit_or_loss
    end

    #Find total staked on odds over 7
    #Find PnL for odds over 7
    @ho7_total_staked = 0
    @ho7_pnl = 0
    for bet in @horse_over_7
      @ho7_total_staked += bet.units_placed
      @ho7_pnl += bet.profit_or_loss
    end

    #Separate the bets into place and win bets
    @horse_under_3_place = @bets.where("sport = ? AND odds < ? AND bet_placed like ?", 7, 3, "%to place%")
    @horse_under_3_win = @bets.where("sport = ? AND odds < ? AND bet_placed like ?", 7, 3, "%to win%")

    #Find total staked on place and win bets for under 3 odds
    @hu3win_total_staked = 0
    @hu3win_pnl = 0
    for bet in @horse_under_3_win
      @hu3win_total_staked += bet.units_placed
      @hu3win_pnl += bet.profit_or_loss
    end

    @hu3place_total_staked = 0
    @hu3place_pnl = 0
    for bet in @horse_under_3_place
      @hu3place_total_staked += bet.units_placed
      @hu3place_pnl += bet.profit_or_loss
    end

    # Total Place Bets
    @horse_place = @bets.where("sport = ? AND bet_placed like ?", 7, "%to place")
    @horse_place_total_staked = 0
    @horse_place_pnl = 0
    for bet in @horse_place
      @horse_place_total_staked += bet.units_placed
      @horse_place_pnl += bet.profit_or_loss
    end

    # Total Win Bets
    @horse_win = @bets.where("sport = ? AND bet_placed like ?", 7, "%to win")
    @horse_win_total_staked = 0
    @horse_win_pnl = 0
    for bet in @horse_win
      @horse_win_total_staked += bet.units_placed
      @horse_win_pnl += bet.profit_or_loss
    end

    #ROI for each Meet
    #Pakenham
    @horse_pakenham = @bets.where("sport = ? AND game like ?", 7, "%Pakenham%")
    @total_pakenham = 0
    @pnl_pakenham = 0
    @roi_pakenham = 0
    for bet in @horse_pakenham
      @total_pakenham += bet.units_placed
      @pnl_pakenham += bet.profit_or_loss
      @roi_pakenham = (@pnl_pakenham / @total_pakenham).round(2)*100
    end

    @horse_broome = @bets.where("sport = ? AND game like ?", 7, "%Broome%")
    @total_broome = 0
    @pnl_broome = 0
    @roi_broome = 0
    for bet in @horse_broome
      @total_broome += bet.units_placed
      @pnl_broome += bet.profit_or_loss
      @roi_broome = (@pnl_broome / @total_broome).round(2)*100
    end

    @horse_geelong = @bets.where("sport = ? AND game like ?", 7, "%Geelong%")
    @total_geelong = 0
    @pnl_geelong = 0
    @roi_geelong = 0
    for bet in @horse_geelong
      @total_geelong += bet.units_placed
      @pnl_geelong += bet.profit_or_loss
      @roi_geelong = (@pnl_geelong / @total_geelong).round(2)*100
    end

    @horse_taree = @bets.where("sport = ? AND game like ?", 7, "%Taree%")
    @total_taree = 0
    @pnl_taree = 0
    @roi_taree = 0
    for bet in @horse_taree
      @total_taree += bet.units_placed
      @pnl_taree += bet.profit_or_loss
      @roi_taree = (@pnl_taree / @total_taree).round(2)*100
    end

    @horse_murraybridge = @bets.where("sport = ? AND game like ?", 7, "%Murray Bridge%")
    @total_murraybridge = 0
    @pnl_murraybridge = 0
    @roi_murraybridge = 0
    for bet in @horse_murraybridge
      @total_murraybridge += bet.units_placed
      @pnl_murraybridge += bet.profit_or_loss
      @roi_murraybridge = (@pnl_murraybridge / @total_murraybridge).round(2)*100
    end

    @horse_gosford = @bets.where("sport = ? AND game like ?", 7, "%Gosford%")
    @total_gosford = 0
    @pnl_gosford = 0
    @roi_gosford = 0
    for bet in @horse_gosford
      @total_gosford += bet.units_placed
      @pnl_gosford += bet.profit_or_loss
      @roi_gosford = (@pnl_gosford / @total_gosford).round(2)*100
    end

    @horse_moree = @bets.where("sport = ? AND game like ?", 7, "%Moree%")
    @total_moree = 0
    @pnl_moree = 0
    @roi_moree = 0
    for bet in @horse_moree
      @total_moree += bet.units_placed
      @pnl_moree += bet.profit_or_loss
      @roi_moree = (@pnl_moree / @total_moree).round(2)*100
    end

    @horse_pinjarra = @bets.where("sport = ? AND game like ?", 7, "%Pinjarra%")
    @total_pinjarra = 0
    @pnl_pinjarra = 0
    @roi_pinjarra = 0
    for bet in @horse_pinjarra
      @total_pinjarra += bet.units_placed
      @pnl_pinjarra += bet.profit_or_loss
      @roi_pinjarra = (@pnl_pinjarra / @total_pinjarra).round(2)*100
    end

    @horse_rockhampton = @bets.where("sport = ? AND game like ?", 7, "%Rockhampton%")
    @total_rockhampton = 0
    @pnl_rockhampton = 0
    @roi_rockhampton = 0
    for bet in @horse_rockhampton
      @total_rockhampton += bet.units_placed
      @pnl_rockhampton += bet.profit_or_loss
      @roi_rockhampton = (@pnl_rockhampton / @total_rockhampton).round(2)*100
    end

    @horse_sale = @bets.where("sport = ? AND game like ?", 7, "%Sale%")
    @total_sale = 0
    @pnl_sale = 0
    @roi_sale = 0
    for bet in @horse_sale
      @total_sale += bet.units_placed
      @pnl_sale += bet.profit_or_loss
      @roi_sale = (@pnl_sale / @total_sale).round(2)*100
    end

    @horse_belmont = @bets.where("sport = ? AND game like ?", 7, "%Belmont%")
    @total_belmont = 0
    @pnl_belmont = 0
    @roi_belmont = 0
    for bet in @horse_belmont
      @total_belmont += bet.units_placed
      @pnl_belmont += bet.profit_or_loss
      @roi_belmont = (@pnl_belmont / @total_belmont).round(2)*100
    end

    @horse_cessnock = @bets.where("sport = ? AND game like ?", 7, "%Cessnock%")
    @total_cessnock = 0
    @pnl_cessnock = 0
    @roi_cessnock = 0
    for bet in @horse_cessnock
      @total_cessnock += bet.units_placed
      @pnl_cessnock += bet.profit_or_loss
      @roi_cessnock = (@pnl_cessnock / @total_cessnock).round(2)*100
    end

    @horse_dalby = @bets.where("sport = ? AND game like ?", 7, "%Dalby%")
    @total_dalby = 0
    @pnl_dalby = 0
    @roi_dalby = 0
    for bet in @horse_dalby
      @total_dalby += bet.units_placed
      @pnl_dalby += bet.profit_or_loss
      @roi_dalby = (@pnl_dalby / @total_dalby).round(2)*100
    end

    @horse_alicesprings = @bets.where("sport = ? AND game like ?", 7, "%Alice Springs%")
    @total_alicesprings = 0
    @pnl_alicesprings = 0
    @roi_alicesprings = 0
    for bet in @horse_alicesprings
      @total_alicesprings += bet.units_placed
      @pnl_alicesprings += bet.profit_or_loss
      @roi_alicesprings = (@pnl_alicesprings / @total_alicesprings).round(2)*100
    end

    @horse_grafton = @bets.where("sport = ? AND game like ?", 7, "%Grafton%")
    @total_grafton = 0
    @pnl_grafton = 0
    @roi_grafton = 0
    for bet in @horse_grafton
      @total_grafton += bet.units_placed
      @pnl_grafton += bet.profit_or_loss
      @roi_grafton = (@pnl_grafton / @total_grafton).round(2)*100
    end

    @horse_kalgoorlie = @bets.where("sport = ? AND game like ?", 7, "%Kalgoorlie%")
    @total_kalgoorlie = 0
    @pnl_kalgoorlie = 0
    @roi_kalgoorlie = 0
    for bet in @horse_kalgoorlie
      @total_kalgoorlie += bet.units_placed
      @pnl_kalgoorlie += bet.profit_or_loss
      @roi_kalgoorlie = (@pnl_kalgoorlie / @total_kalgoorlie).round(2)*100
    end

    @horse_wodonga = @bets.where("sport = ? AND game like ?", 7, "%Wodonga%")
    @total_wodonga = 0
    @pnl_wodonga = 0
    @roi_wodonga = 0
    for bet in @horse_wodonga
      @total_wodonga += bet.units_placed
      @pnl_wodonga += bet.profit_or_loss
      @roi_wodonga = (@pnl_wodonga / @total_wodonga).round(2)*100
    end

    @horse_carnarvon = @bets.where("sport = ? AND game like ?", 7, "%Carnarvon%")
    @total_carnarvon = 0
    @pnl_carnarvon = 0
    @roi_carnarvon = 0
    for bet in @horse_carnarvon
      @total_carnarvon += bet.units_placed
      @pnl_carnarvon += bet.profit_or_loss
      @roi_carnarvon = (@pnl_carnarvon / @total_carnarvon).round(2)*100
    end

    @horse_caulfield = @bets.where("sport = ? AND game like ?", 7, "%Caulfield%")
    @total_caulfield = 0
    @pnl_caulfield = 0
    @roi_caulfield = 0
    for bet in @horse_caulfield
      @total_caulfield += bet.units_placed
      @pnl_caulfield += bet.profit_or_loss
      @roi_caulfield = (@pnl_caulfield / @total_caulfield).round(2)*100
    end

    @horse_darwin = @bets.where("sport = ? AND game like ?", 7, "%Darwin%")
    @total_darwin = 0
    @pnl_darwin = 0
    @roi_darwin = 0
    for bet in @horse_darwin
      @total_darwin += bet.units_placed
      @pnl_darwin += bet.profit_or_loss
      @roi_darwin = (@pnl_darwin / @total_darwin).round(2)*100
    end

    @horse_eaglefarm = @bets.where("sport = ? AND game like ?", 7, "%Eagle Farm%")
    @total_eaglefarm = 0
    @pnl_eaglefarm = 0
    @roi_eaglefarm = 0
    for bet in @horse_eaglefarm
      @total_eaglefarm += bet.units_placed
      @pnl_eaglefarm += bet.profit_or_loss
      @roi_eaglefarm = (@pnl_eaglefarm / @total_eaglefarm).round(2)*100
    end

    @horse_echuca = @bets.where("sport = ? AND game like ?", 7, "%Echuca%")
    @total_echuca = 0
    @pnl_echuca = 0
    @roi_echuca = 0
    for bet in @horse_echuca
      @total_echuca += bet.units_placed
      @pnl_echuca += bet.profit_or_loss
      @roi_echuca = (@pnl_echuca / @total_echuca).round(2)*100
    end

    @horse_gawler = @bets.where("sport = ? AND game like ?", 7, "%Gawler%")
    @total_gawler = 0
    @pnl_gawler = 0
    @roi_gawler = 0
    for bet in @horse_gawler
      @total_gawler += bet.units_placed
      @pnl_gawler += bet.profit_or_loss
      @roi_gawler = (@pnl_gawler / @total_gawler).round(2)*100
    end

    @horse_kembla = @bets.where("sport = ? AND game like ?", 7, "%Kembla%")
    @total_kembla = 0
    @pnl_kembla = 0
    @roi_kembla = 0
    for bet in @horse_kembla
      @total_kembla += bet.units_placed
      @pnl_kembla += bet.profit_or_loss
      @roi_kembla = (@pnl_kembla / @total_kembla).round(2)*100
    end

    @horse_rosehill = @bets.where("sport = ? AND game like ?", 7, "%Rosehill%")
    @total_rosehill = 0
    @pnl_rosehill = 0
    @roi_rosehill = 0
    for bet in @horse_rosehill
      @total_rosehill += bet.units_placed
      @pnl_rosehill += bet.profit_or_loss
      @roi_rosehill = (@pnl_rosehill / @total_rosehill).round(2)*100
    end

    @horse_townsville = @bets.where("sport = ? AND game like ?", 7, "%Townsville%")
    @total_townsville = 0
    @pnl_townsville = 0
    @roi_townsville = 0
    for bet in @horse_townsville
      @total_townsville += bet.units_placed
      @pnl_townsville += bet.profit_or_loss
      @roi_townsville = (@pnl_townsville / @total_townsville).round(2)*100
    end

    @horse_tuncurry = @bets.where("sport = ? AND game like ?", 7, "%Tuncurry%")
    @total_tuncurry = 0
    @pnl_tuncurry = 0
    @roi_tuncurry = 0
    for bet in @horse_tuncurry
      @total_tuncurry += bet.units_placed
      @pnl_tuncurry += bet.profit_or_loss
      @roi_tuncurry = (@pnl_tuncurry / @total_tuncurry).round(2)*100
    end

    @horse_cranbourne = @bets.where("sport = ? AND game like ?", 7, "%Cranbourne%")
    @total_cranbourne = 0
    @pnl_cranbourne = 0
    @roi_cranbourne = 0
    for bet in @horse_cranbourne
      @total_cranbourne += bet.units_placed
      @pnl_cranbourne += bet.profit_or_loss
      @roi_cranbourne = (@pnl_cranbourne / @total_cranbourne).round(2)*100
    end

    @horse_northam = @bets.where("sport = ? AND game like ?", 7, "%Northam%")
    @total_northam = 0
    @pnl_northam = 0
    @roi_northam = 0
    for bet in @horse_northam
      @total_northam += bet.units_placed
      @pnl_northam += bet.profit_or_loss
      @roi_northam = (@pnl_northam / @total_northam).round(2)*100
    end

    @horse_devonport = @bets.where("sport = ? AND game like ?", 7, "%Devonport%")
    @total_devonport = 0
    @pnl_devonport = 0
    @roi_devonport = 0
    for bet in @horse_devonport
      @total_devonport += bet.units_placed
      @pnl_devonport += bet.profit_or_loss
      @roi_devonport = (@pnl_devonport / @total_devonport).round(2)*100
    end

    @horse_doomben = @bets.where("sport = ? AND game like ?", 7, "%Doomben%")
    @total_doomben = 0
    @pnl_doomben = 0
    @roi_doomben = 0
    for bet in @horse_doomben
      @total_doomben += bet.units_placed
      @pnl_doomben += bet.profit_or_loss
      @roi_doomben = (@pnl_doomben / @total_doomben).round(2)*100
    end

    @horse_flemington = @bets.where("sport = ? AND game like ?", 7, "%Flemington%")
    @total_flemington = 0
    @pnl_flemington = 0
    @roi_flemington = 0
    for bet in @horse_flemington
      @total_flemington += bet.units_placed
      @pnl_flemington += bet.profit_or_loss
      @roi_flemington = (@pnl_flemington / @total_flemington).round(2)*100
    end

    @horse_goldcoast = @bets.where("sport = ? AND game like ?", 7, "%Gold Coast%")
    @total_goldcoast = 0
    @pnl_goldcoast = 0
    @roi_goldcoast = 0
    for bet in @horse_goldcoast
      @total_goldcoast += bet.units_placed
      @pnl_goldcoast += bet.profit_or_loss
      @roi_goldcoast = (@pnl_goldcoast / @total_goldcoast).round(2)*100
    end

    @horse_morphettville = @bets.where("sport = ? AND game like ?", 7, "%Morphettville%")
    @total_morphettville = 0
    @pnl_morphettville = 0
    @roi_morphettville = 0
    for bet in @horse_morphettville
      @total_morphettville += bet.units_placed
      @pnl_morphettville += bet.profit_or_loss
      @roi_morphettville = (@pnl_morphettville / @total_morphettville).round(2)*100
    end

    @horse_randwick = @bets.where("sport = ? AND game like ?", 7, "%Randwick%")
    @total_randwick = 0
    @pnl_randwick = 0
    @roi_randwick = 0
    for bet in @horse_randwick
      @total_randwick += bet.units_placed
      @pnl_randwick += bet.profit_or_loss
      @roi_randwick = (@pnl_randwick / @total_randwick).round(2)*100
    end

    @horse_toowoomba = @bets.where("sport = ? AND game like ?", 7, "%Toowoomba%")
    @total_toowoomba = 0
    @pnl_toowoomba = 0
    @roi_toowoomba = 0
    for bet in @horse_toowoomba
      @total_toowoomba += bet.units_placed
      @pnl_toowoomba += bet.profit_or_loss
      @roi_toowoomba = (@pnl_toowoomba / @total_toowoomba).round(2)*100
    end

    @horse_ipswich = @bets.where("sport = ? AND game like ?", 7, "%Ipswich%")
    @total_ipswich = 0
    @pnl_ipswich = 0
    @roi_ipswich = 0
    for bet in @horse_ipswich
      @total_ipswich += bet.units_placed
      @pnl_ipswich += bet.profit_or_loss
      @roi_ipswich = (@pnl_ipswich / @total_ipswich).round(2)*100
    end

    @horse_scone = @bets.where("sport = ? AND game like ?", 7, "%Scone%")
    @total_scone = 0
    @pnl_scone = 0
    @roi_scone = 0
    for bet in @horse_scone
      @total_scone += bet.units_placed
      @pnl_scone += bet.profit_or_loss
      @roi_scone = (@pnl_scone / @total_scone).round(2)*100
    end

    @horse_hawkesbury = @bets.where("sport = ? AND game like ?", 7, "%Hawkesbury%")
    @total_hawkesbury = 0
    @pnl_hawkesbury = 0
    @roi_hawkesbury = 0
    for bet in @horse_hawkesbury
      @total_hawkesbury += bet.units_placed
      @pnl_hawkesbury += bet.profit_or_loss
      @roi_hawkesbury = (@pnl_hawkesbury / @total_hawkesbury).round(2)*100
    end

    @horse_mackay = @bets.where("sport = ? AND game like ?", 7, "%Mackay%")
    @total_mackay = 0
    @pnl_mackay = 0
    @roi_mackay = 0
    for bet in @horse_mackay
      @total_mackay += bet.units_placed
      @pnl_mackay += bet.profit_or_loss
      @roi_mackay = (@pnl_mackay / @total_mackay).round(2)*100
    end

    @horse_canterbury = @bets.where("sport = ? AND game like ?", 7, "%Canterbury%")
    @total_canterbury = 0
    @pnl_canterbury = 0
    @roi_canterbury = 0
    for bet in @horse_canterbury
      @total_canterbury += bet.units_placed
      @pnl_canterbury += bet.profit_or_loss
      @roi_canterbury = (@pnl_canterbury / @total_canterbury).round(2)*100
    end

    @horse_sandown = @bets.where("sport = ? AND game like ?", 7, "%Sandown%")
    @total_sandown = 0
    @pnl_sandown = 0
    @roi_sandown = 0
    for bet in @horse_sandown
      @total_sandown += bet.units_placed
      @pnl_sandown += bet.profit_or_loss
      @roi_sandown = (@pnl_sandown / @total_sandown).round(2)*100
    end

    @horse_corowa = @bets.where("sport = ? AND game like ?", 7, "%Corowa%")
    @total_corowa = 0
    @pnl_corowa = 0
    @roi_corowa = 0
    for bet in @horse_corowa
      @total_corowa += bet.units_placed
      @pnl_corowa += bet.profit_or_loss
      @roi_corowa = (@pnl_corowa / @total_corowa).round(2)*100
    end

    @horse_kembla = @bets.where("sport = ? AND game like ?", 7, "%Kembla%")
    @total_kembla = 0
    @pnl_kembla = 0
    @roi_kembla = 0
    for bet in @horse_kembla
      @total_kembla += bet.units_placed
      @pnl_kembla += bet.profit_or_loss
      @roi_kembla = (@pnl_kembla / @total_kembla).round(2)*100
    end

    @horse_mildura = @bets.where("sport = ? AND game like ?", 7, "%Mildura%")
    @total_mildura = 0
    @pnl_mildura = 0
    @roi_mildura = 0
    for bet in @horse_mildura
      @total_mildura += bet.units_placed
      @pnl_mildura += bet.profit_or_loss
      @roi_mildura = (@pnl_mildura / @total_mildura).round(2)*100
    end

    @horse_bordertown = @bets.where("sport = ? AND game like ?", 7, "%Bordertown%")
    @total_bordertown = 0
    @pnl_bordertown = 0
    @roi_bordertown = 0
    for bet in @horse_bordertown
      @total_bordertown += bet.units_placed
      @pnl_bordertown += bet.profit_or_loss
      @roi_bordertown = (@pnl_bordertown / @total_bordertown).round(2)*100
    end

    @horse_casterton = @bets.where("sport = ? AND game like ?", 7, "%Casterton%")
    @total_casterton = 0
    @pnl_casterton = 0
    @roi_casterton = 0
    for bet in @horse_casterton
      @total_casterton += bet.units_placed
      @pnl_casterton += bet.profit_or_loss
      @roi_casterton = (@pnl_casterton / @total_casterton).round(2)*100
    end

    @horse_launceston = @bets.where("sport = ? AND game like ?", 7, "%Launceston%")
    @total_launceston = 0
    @pnl_launceston = 0
    @roi_launceston = 0
    for bet in @horse_launceston
      @total_launceston += bet.units_placed
      @pnl_launceston += bet.profit_or_loss
      @roi_launceston = (@pnl_launceston / @total_launceston).round(2)*100
    end

    @horse_mudgee = @bets.where("sport = ? AND game like ?", 7, "%Mudgee%")
    @total_mudgee = 0
    @pnl_mudgee = 0
    @roi_mudgee = 0
    for bet in @horse_mudgee
      @total_mudgee += bet.units_placed
      @pnl_mudgee += bet.profit_or_loss
      @roi_mudgee = (@pnl_mudgee / @total_mudgee).round(2)*100
    end

    @horse_sapphirecoast = @bets.where("sport = ? AND game like ?", 7, "%Sapphire Coast%")
    @total_sapphirecoast = 0
    @pnl_sapphirecoast = 0
    @roi_sapphirecoast = 0
    for bet in @horse_sapphirecoast
      @total_sapphirecoast += bet.units_placed
      @pnl_sapphirecoast += bet.profit_or_loss
      @roi_sapphirecoast = (@pnl_sapphirecoast / @total_sapphirecoast).round(2)*100
    end

    @horse_donald = @bets.where("sport = ? AND game like ?", 7, "%Donald%")
    @total_donald = 0
    @pnl_donald = 0
    @roi_donald = 0
    for bet in @horse_donald
      @total_donald += bet.units_placed
      @pnl_donald += bet.profit_or_loss
      @roi_donald = (@pnl_donald / @total_donald).round(2)*100
    end

    @horse_muswellbrook = @bets.where("sport = ? AND game like ?", 7, "%Muswellbrook%")
    @total_muswellbrook = 0
    @pnl_muswellbrook = 0
    @roi_muswellbrook = 0
    for bet in @horse_muswellbrook
      @total_muswellbrook += bet.units_placed
      @pnl_muswellbrook += bet.profit_or_loss
      @roi_muswellbrook = (@pnl_muswellbrook / @total_muswellbrook).round(2)*100
    end

    @horse_wyong = @bets.where("sport = ? AND game like ?", 7, "%Wyong%")
    @total_wyong = 0
    @pnl_wyong = 0
    @roi_wyong = 0
    for bet in @horse_wyong
      @total_wyong += bet.units_placed
      @pnl_wyong += bet.profit_or_loss
      @roi_wyong = (@pnl_wyong / @total_wyong).round(2)*100
    end

    @horse_bendigo = @bets.where("sport = ? AND game like ?", 7, "%Bendigo%")
    @total_bendigo = 0
    @pnl_bendigo = 0
    @roi_bendigo = 0
    for bet in @horse_bendigo
      @total_bendigo += bet.units_placed
      @pnl_bendigo += bet.profit_or_loss
      @roi_bendigo = (@pnl_bendigo / @total_bendigo).round(2)*100
    end

    @horse_goulburn = @bets.where("sport = ? AND game like ?", 7, "%Goulburn%")
    @total_goulburn = 0
    @pnl_goulburn = 0
    @roi_goulburn = 0
    for bet in @horse_goulburn
      @total_goulburn += bet.units_placed
      @pnl_goulburn += bet.profit_or_loss
      @roi_goulburn = (@pnl_goulburn / @total_goulburn).round(2)*100
    end

    @horse_nowra = @bets.where("sport = ? AND game like ?", 7, "%Nowra%")
    @total_nowra = 0
    @pnl_nowra = 0
    @roi_nowra = 0
    for bet in @horse_nowra
      @total_nowra += bet.units_placed
      @pnl_nowra += bet.profit_or_loss
      @roi_nowra = (@pnl_nowra / @total_nowra).round(2)*100
    end

    @horse_warwickfarm = @bets.where("sport = ? AND game like ?", 7, "%Warwick Farm%")
    @total_warwickfarm = 0
    @pnl_warwickfarm = 0
    @roi_warwickfarm = 0
    for bet in @horse_warwickfarm
      @total_warwickfarm += bet.units_placed
      @pnl_warwickfarm += bet.profit_or_loss
      @roi_warwickfarm = (@pnl_warwickfarm / @total_warwickfarm).round(2)*100
    end

    @horse_wagga = @bets.where("sport = ? AND game like ?", 7, "%Wagga%")
    @total_wagga = 0
    @pnl_wagga = 0
    @roi_wagga = 0
    for bet in @horse_wagga
      @total_wagga += bet.units_placed
      @pnl_wagga += bet.profit_or_loss
      @roi_wagga = (@pnl_wagga / @total_wagga).round(2)*100
    end

    @horse_coleraine = @bets.where("sport = ? AND game like ?", 7, "%Coleraine%")
    @total_coleraine = 0
    @pnl_coleraine = 0
    @roi_coleraine = 0
    for bet in @horse_coleraine
      @total_coleraine += bet.units_placed
      @pnl_coleraine += bet.profit_or_loss
      @roi_coleraine = (@pnl_coleraine / @total_coleraine).round(2)*100
    end

    @horse_murwillumbah = @bets.where("sport = ? AND game like ?", 7, "%Murwillumbah%")
    @total_murwillumbah = 0
    @pnl_murwillumbah = 0
    @roi_murwillumbah = 0
    for bet in @horse_murwillumbah
      @total_murwillumbah += bet.units_placed
      @pnl_murwillumbah += bet.profit_or_loss
      @roi_murwillumbah = (@pnl_murwillumbah / @total_murwillumbah).round(2)*100
    end

    @horse_portaugusta = @bets.where("sport = ? AND game like ?", 7, "%Port Augusta%")
    @total_portaugusta = 0
    @pnl_portaugusta = 0
    @roi_portaugusta = 0
    for bet in @horse_portaugusta
      @total_portaugusta += bet.units_placed
      @pnl_portaugusta += bet.profit_or_loss
      @roi_portaugusta = (@pnl_portaugusta / @total_portaugusta).round(2)*100
    end

    @horse_beaudesert = @bets.where("sport = ? AND game like ?", 7, "%Beaudesert%")
    @total_beaudesert = 0
    @pnl_beaudesert = 0
    @roi_beaudesert = 0
    for bet in @horse_beaudesert
      @total_beaudesert += bet.units_placed
      @pnl_beaudesert += bet.profit_or_loss
      @roi_beaudesert = (@pnl_beaudesert / @total_beaudesert).round(2)*100
    end

    @horse_moe = @bets.where("sport = ? AND game like ?", 7, "%Moe%")
    @total_moe = 0
    @pnl_moe = 0
    @roi_moe = 0
    for bet in @horse_moe
      @total_moe += bet.units_placed
      @pnl_moe += bet.profit_or_loss
      @roi_moe = (@pnl_moe / @total_moe).round(2)*100
    end

    @horse_canberra = @bets.where("sport = ? AND game like ?", 7, "%Canberra%")
    @total_canberra = 0
    @pnl_canberra = 0
    @roi_canberra = 0
    for bet in @horse_canberra
      @total_canberra += bet.units_placed
      @pnl_canberra += bet.profit_or_loss
      @roi_canberra = (@pnl_canberra / @total_canberra).round(2)*100
    end

    @horse_coffsharbour = @bets.where("sport = ? AND game like ?", 7, "%Coffs Harbour%")
    @total_coffsharbour = 0
    @pnl_coffsharbour = 0
    @roi_coffsharbour = 0
    for bet in @horse_coffsharbour
      @total_coffsharbour += bet.units_placed
      @pnl_coffsharbour += bet.profit_or_loss
      @roi_coffsharbour = (@pnl_coffsharbour / @total_coffsharbour).round(2)*100
    end

    @horse_newcastle = @bets.where("sport = ? AND game like ?", 7, "%Newcastle%")
    @total_newcastle = 0
    @pnl_newcastle = 0
    @roi_newcastle = 0
    for bet in @horse_newcastle
      @total_newcastle += bet.units_placed
      @pnl_newcastle += bet.profit_or_loss
      @roi_newcastle = (@pnl_newcastle / @total_newcastle).round(2)*100
    end

    @horse_hamilton = @bets.where("sport = ? AND game like ?", 7, "%Hamilton%")
    @total_hamilton = 0
    @pnl_hamilton = 0
    @roi_hamilton = 0
    for bet in @horse_hamilton
      @total_hamilton += bet.units_placed
      @pnl_hamilton += bet.profit_or_loss
      @roi_hamilton = (@pnl_hamilton / @total_hamilton).round(2)*100
    end

    @horse_naracoorte = @bets.where("sport = ? AND game like ?", 7, "%Naracoorte%")
    @total_naracoorte = 0
    @pnl_naracoorte = 0
    @roi_naracoorte = 0
    for bet in @horse_naracoorte
      @total_naracoorte += bet.units_placed
      @pnl_naracoorte += bet.profit_or_loss
      @roi_naracoorte = (@pnl_naracoorte / @total_naracoorte).round(2)*100
    end

  end

end
