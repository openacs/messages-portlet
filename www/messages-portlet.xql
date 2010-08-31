<?xml version="1.0"?>
<queryset>

    <fullquery name="count_new_messages">
        <querytext>
                select count (case when um.new_p = 't' then 1 end ) as new_t,count (um.new_p) as total
                from (select distinct(parent_id) as msg_id,folder_id,new_p
                        from messages_user_messages 
                        where user_id = :user_id
                        and folder_id not in ($folder_ids)
                        ) um,
                      (select msg_id 
                        from messages_messages 
                        where community_id = :community_id) m
                where um.msg_id = m.msg_id
                group by um.folder_id
                order by folder_id
        </querytext>
    </fullquery>

</queryset>
