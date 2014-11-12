CREATE TABLE [dbo].[Tipo_Combustivel] (
    [cd_tipo_combustivel]     INT          NOT NULL,
    [nm_tipo_combustivel]     VARCHAR (30) NULL,
    [sg_tipo_combustivel]     CHAR (10)    NULL,
    [ic_pad_tipo_combustivel] CHAR (1)     NULL,
    [vl_tipo_combustivel]     FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Combustivel] PRIMARY KEY CLUSTERED ([cd_tipo_combustivel] ASC) WITH (FILLFACTOR = 90)
);

