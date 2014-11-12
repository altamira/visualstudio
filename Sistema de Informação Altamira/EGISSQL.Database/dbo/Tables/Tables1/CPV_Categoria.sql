CREATE TABLE [dbo].[CPV_Categoria] (
    [cd_cpv_categoria] INT          NOT NULL,
    [nm_cpv_categoria] VARCHAR (40) NULL,
    [sg_cpv_categoria] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_CPV_Categoria] PRIMARY KEY CLUSTERED ([cd_cpv_categoria] ASC) WITH (FILLFACTOR = 90)
);

