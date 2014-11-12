CREATE TABLE [dbo].[Carta_Anuencia] (
    [cd_carta_anuencia]     INT          NOT NULL,
    [dt_carta_anuencia]     DATETIME     NULL,
    [nm_obs_carta_anuencia] VARCHAR (40) NULL,
    [vl_carta_anuencia]     FLOAT (53)   NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_cliente]            INT          NULL,
    CONSTRAINT [PK_Carta_Anuencia] PRIMARY KEY CLUSTERED ([cd_carta_anuencia] ASC) WITH (FILLFACTOR = 90)
);

