SELECT source.ips_item_id AS sourceitemid, source.ips_site_page AS sourcelink, CONCAT( redirect.rd_title, COALESCE( redirect.rd_fragment, "" ) ) AS redirecttarget, target.ips_site_page AS targelink, target.ips_item_id AS
targetitemid
    FROM
        wikidatawiki_p.wb_items_per_site source -- item pointing to the redirecting wikipage
        INNER JOIN %1$s_p.page sourcepage -- {$wiki}
            ON REPLACE( source.ips_site_page, " " , "_" ) = sourcepage.page_title -- identifying the redirecting wikipage locally
            -- I know REPLACE() breaks indexes, but sadly I don't know of a workaround for the space/underscore mismatch
        INNER JOIN %1$s_p.redirect redirect -- {$wiki}
            ON sourcepage.page_id = redirect.rd_from -- identifying the redirect target locally
        INNER JOIN wikidatawiki_p.wb_items_per_site target
            ON redirect.rd_title = REPLACE( target.ips_site_page, " ", "_" ) -- item the redirect target corresponds to
            -- as stated earlier, I know REPLACE() breaks indexes, but sadly I don't know of a workaround for the space/underscore mismatch
    WHERE
        source.ips_site_id = "%1$s" -- {$wiki}
        AND target.ips_site_id = "%1$s" -- {$wiki}
        AND sourcepage.page_namespace = 0
