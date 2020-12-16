3.times do |i|
   Author.create!({first_name: "First#{i}", last_name: "Last#{i}"})
end

4.times do |i|
   64.times do |i|
      Post.create!({ title: "Post#{i}",
                     body: "Lorem Ipsum",
                     published_at: (Time.now + i*8)})
      Post.last.comments.create!({body: "Lorem Ipsum Comment1",
                                  author_id: 1})
      Post.last.comments.create!({body: "Lorem Ipsum Comment1",
                                  author_id: 2})
      Post.last.comments.create!({body: "Lorem Ipsum Comment1",
                                  author_id: 3})
   end

   64.times do |i|
      Post.create!({ title: "Post#{i}",
                     body: "Lorem Ipsum",})
      Post.last.comments.create!({body: "Lorem Ipsum Comment1",
                                  author_id: 1})
      Post.last.comments.create!({body: "Lorem Ipsum Comment1",
                                  author_id: 2})
      Post.last.comments.create!({body: "Lorem Ipsum Comment1",
                                  author_id: 3})
   end
end


