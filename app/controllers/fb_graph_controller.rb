class FbGraphController < ApplicationController
  FBREQUESTURL = <<END
https://graph.facebook.com/123103684386135/posts\
?fields=id,from,message,picture,link,type,\
status_type,object_id,created_time,likes.limit(1).summary(true),\
shares,comments.limit(1).summary(true)&access_token=\
CAAUT3ZAXoe9kBAMK0ZANkwNZBmtwZBBt8diursY2OppDN6HNaPzWBqJK5BWGjbBG\
1DCqTWZCoHaKVVx7QudeQ4lEXfuyHiWXKKvepsifZA2gggSjA6mk3Izt2bSKnlKxz\
BIwIQyG2p4mLvgSwJQLERdtek2ZB0gM6PHjZAD7ZBNjZB1JXjALsiC9eo
END
  
  def index
    fbrequest
    @posts = Fbpost.all #first
    render json: @posts
  end

  private
  def fbrequest
    uri = URI(FBREQUESTURL)
    res = Net::HTTP.get_response(uri)
    data = JSON.parse(res.body)['data']
    transform(data)
    data.each do |post|
      Fbpost.create!(post) unless Fbpost.exists?( :fb_id => post['fb_id'] )
    end
  end

  def transform( data )
    data.map! do |post|
      post.merge!( {
	'from_name' => post['from']['name'],
	'from_id' => post['from']['id'],
	'fb_id' => post.delete('id'),
	'fb_type' => post.delete('type'),
	'fb_object_id' => post.delete('object_id'),
	'likes_count' => (post['likes'] ? post['likes']['summary']['total_count'] : 0),
	'shares_count' => (post['shares'] ? post['shares']['count'] : 0),
	'comments_count' => (post['comments'] ? post['comments']['summary']['total_count'] : 0),
      } )
      post['hotscore'] = post['likes_count'] + 5 * post['shares_count'] + 2 * post['comments_count']
      post.except!('from', 'likes', 'shares', 'comments')
    end
  end
 
end
