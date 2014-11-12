CREATE TABLE [dbo].[Requisito_Cargo] (
    [cd_requisito_cargo] INT          NOT NULL,
    [nm_requisito_cargo] VARCHAR (60) NULL,
    [ds_requisito_cargo] TEXT         NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Requisito_Cargo] PRIMARY KEY CLUSTERED ([cd_requisito_cargo] ASC) WITH (FILLFACTOR = 90)
);

