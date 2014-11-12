CREATE TABLE [dbo].[Cemiterio_Quadra] (
    [cd_cemiterio]        INT       NOT NULL,
    [cd_cemiterio_quadra] INT       NOT NULL,
    [sg_cemiterio_quadra] CHAR (20) NOT NULL,
    [ds_cemiterio_quadra] TEXT      NULL,
    [cd_usuario]          INT       NULL,
    [dt_usuario]          DATETIME  NULL,
    CONSTRAINT [FK_Cemiterio_Quadra_Cemiterio] FOREIGN KEY ([cd_cemiterio]) REFERENCES [dbo].[Cemiterio] ([cd_cemiterio])
);

