CREATE TABLE [dbo].[CPV_Fracionado] (
    [cd_ano]           INT        NOT NULL,
    [cd_mes]           INT        NOT NULL,
    [cd_cpv_categoria] INT        NOT NULL,
    [vl_cpv_categoria] FLOAT (53) NULL,
    [cd_usuario]       INT        NULL,
    [dt_usuario]       DATETIME   NULL,
    CONSTRAINT [PK_CPV_Fracionado] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_mes] ASC, [cd_cpv_categoria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CPV_Fracionado_CPV_Categoria] FOREIGN KEY ([cd_cpv_categoria]) REFERENCES [dbo].[CPV_Categoria] ([cd_cpv_categoria])
);

