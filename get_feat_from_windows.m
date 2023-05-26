function win_feat_all = get_feat_from_windows(var, vel, th_urb, th_rur, w)

urb = var(vel<th_urb);
veln_rur = var(vel>=th_urb & vel < th_rur);
veln_car = var(vel>=th_rur);

get_win = @(x, w) reshape(x(1:floor(size(x,2)/w)*w),[],w);
get_feat_win = @(x, t) [t*ones(size(x,1),1), mean(x,2), std(x,[],2)];
urb_win = get_win(urb, w);
rur_win = get_win(veln_rur, w);
car_win = get_win(veln_car, w);

urb_win_feat = get_feat_win(urb_win,1);
rur_win_feat = get_feat_win(rur_win,2);
car_win_feat = get_feat_win(car_win,3);

win_feat_all =[urb_win_feat; rur_win_feat; car_win_feat];