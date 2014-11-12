﻿CREATE TABLE [dbo].[APC_Sport] (
    [cd_conta_sport]   INT          NOT NULL,
    [cd_mascara_conta] VARCHAR (30) NOT NULL,
    [nm_conta_sport]   VARCHAR (60) NULL,
    [ic_status_conta]  CHAR (1)     NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_APC_Sport] PRIMARY KEY CLUSTERED ([cd_conta_sport] ASC)
);

