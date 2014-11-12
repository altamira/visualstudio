CREATE TABLE [dbo].[Controle_Deposito] (
    [cd_controle_deposito]     INT          NOT NULL,
    [cd_solicitacao]           INT          NULL,
    [cd_prestacao]             INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_deposito]              INT          NULL,
    [nm_obs_controle_deposito] VARCHAR (40) NULL,
    CONSTRAINT [PK_Controle_Deposito] PRIMARY KEY CLUSTERED ([cd_controle_deposito] ASC) WITH (FILLFACTOR = 90)
);

