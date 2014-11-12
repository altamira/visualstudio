CREATE TABLE [dbo].[Tipo_Container] (
    [cd_tipo_container] INT          NOT NULL,
    [nm_tipo_container] VARCHAR (40) NULL,
    [ds_tipo_container] TEXT         NULL,
    [qt_tipo_container] FLOAT (53)   NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [cd_unidade_medida] INT          NULL,
    CONSTRAINT [PK_Tipo_Container] PRIMARY KEY CLUSTERED ([cd_tipo_container] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Container_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

