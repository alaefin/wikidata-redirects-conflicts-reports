SELECT DISTINCT wbc_entity_usage.eu_entity_id, page.page_namespace, redirect.rd_namespace, REPLACE( page.page_title, "_", " ") AS page_title,
    COALESCE( CONCAT( redirect.rd_title, "#", NULLIF( redirect.rd_fragment, "" ) ), redirect.rd_title ) AS rd_title
FROM wbc_entity_usage
    INNER JOIN page
        ON wbc_entity_usage.eu_page_id = page.page_id
    INNER JOIN redirect
        ON redirect.rd_from = page.page_id
    WHERE
        page.page_is_redirect = 1
