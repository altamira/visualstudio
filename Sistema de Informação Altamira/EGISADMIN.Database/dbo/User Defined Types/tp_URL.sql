﻿CREATE TYPE [dbo].[tp_URL]
    FROM VARCHAR (50) NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[tp_URL] TO PUBLIC
    AS [dbo];

