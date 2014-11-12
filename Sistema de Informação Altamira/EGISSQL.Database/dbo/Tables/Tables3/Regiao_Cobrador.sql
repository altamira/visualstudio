CREATE TABLE [dbo].[Regiao_Cobrador] (
    [cd_regiao_cobrador]       INT          NOT NULL,
    [nm_regiao_cobrador]       VARCHAR (40) NULL,
    [sg_regiao_cobrador]       CHAR (15)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_ativa_regiao_cobrador] CHAR (1)     NULL,
    [ds_regiao_cobrador]       TEXT         NULL,
    CONSTRAINT [PK_regiao_cobrador] PRIMARY KEY CLUSTERED ([cd_regiao_cobrador] ASC) WITH (FILLFACTOR = 90)
);

