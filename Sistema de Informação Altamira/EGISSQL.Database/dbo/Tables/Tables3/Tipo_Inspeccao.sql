CREATE TABLE [dbo].[Tipo_Inspeccao] (
    [cd_tipo_inspeccao]     INT          NOT NULL,
    [nm_tipo_inspeccao]     VARCHAR (40) NULL,
    [sg_tipo_inspeccao]     CHAR (10)    NULL,
    [ic_plano_controle]     CHAR (1)     NULL,
    [cd_cor_tipo_inspeccao] VARCHAR (15) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Inspeccao] PRIMARY KEY CLUSTERED ([cd_tipo_inspeccao] ASC) WITH (FILLFACTOR = 90)
);

