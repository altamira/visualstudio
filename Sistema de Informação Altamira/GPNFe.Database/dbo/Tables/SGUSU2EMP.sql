﻿CREATE TABLE [dbo].[SGUSU2EMP] (
    [SgUsu0Cod]    CHAR (20) NOT NULL,
    [SgUsu2EmpCod] CHAR (2)  NOT NULL,
    [SgUsu2EmpSel] SMALLINT  NOT NULL,
    CONSTRAINT [PK_SGUSU2EMP] PRIMARY KEY CLUSTERED ([SgUsu0Cod] ASC, [SgUsu2EmpCod] ASC)
);

