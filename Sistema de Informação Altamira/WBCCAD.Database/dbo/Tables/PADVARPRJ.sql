﻿CREATE TABLE [dbo].[PADVARPRJ] (
    [PADVARPRJ_VARIAVEL] NVARCHAR (30)  NULL,
    [PADVARPRJ_VALOR]    NVARCHAR (MAX) NULL,
    [IDPADVARPRJ]        INT            IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([IDPADVARPRJ] ASC)
);

