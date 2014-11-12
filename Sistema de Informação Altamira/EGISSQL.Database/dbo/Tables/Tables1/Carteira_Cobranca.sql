CREATE TABLE [dbo].[Carteira_Cobranca] (
    [cd_carteira_cobranca]     INT          NOT NULL,
    [nm_carteira_cobranca]     VARCHAR (50) NOT NULL,
    [sg_carteira_cobranca]     CHAR (10)    NULL,
    [cd_num_carteira_cobranca] INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_compl_carteira]        VARCHAR (15) NULL,
    CONSTRAINT [PK_Carteira_Cobranca] PRIMARY KEY CLUSTERED ([cd_carteira_cobranca] ASC) WITH (FILLFACTOR = 90)
);

