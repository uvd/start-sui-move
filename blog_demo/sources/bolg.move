module blog_demo::bolg {
    use sui::object::UID;
    use std::string::String;
    use sui::tx_context::{TxContext};
    use sui::object;
    use sui::transfer;

    public struct Blog has key {
        id: UID,
        title: String,
        content: String
    }

    public struct TimeEvent has copy,drop{
        time:u64
    }

    // add blog
    public entry fun add(title: String, content: String, ctx: &mut TxContext) {
        let blog = Blog {
            id: object::new(ctx),
            title,
            content
        };
        transfer::share_object(blog);
    }

    // update title
    public entry fun update_title(blog: &mut Blog, title: String) {
        blog.title = title
    }

    // delete blog
    public entry fun delete_bolg(blog:Blog){
        let Blog{id,title:_,content:_} = blog;
        object::delete(id);
    }
}
