CREATE TABLE [dbo].[Cobrador_Regiao] (
    [cd_cobrador]             INT          NOT NULL,
    [cd_regiao_cobrador]      INT          NOT NULL,
    [cd_item_cobrador_regiao] INT          NOT NULL,
    [nm_obs_cobrador_regiao]  VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [vl_pot_cobrador_regiao]  FLOAT (53)   NULL,
    CONSTRAINT [PK_Cobrador_Regiao] PRIMARY KEY CLUSTERED ([cd_cobrador] ASC, [cd_regiao_cobrador] ASC, [cd_item_cobrador_regiao] ASC) WITH (FILLFACTOR = 90)
);

