CREATE TABLE [dbo].[Componente_Engenharia] (
    [cd_componente] INT           NOT NULL,
    [nm_componente] VARCHAR (60)  NULL,
    [nm_imagem]     VARCHAR (120) NULL,
    [cd_usuario]    INT           NULL,
    [dt_usuario]    DATETIME      NULL,
    CONSTRAINT [PK_Componente_Engenharia] PRIMARY KEY CLUSTERED ([cd_componente] ASC) WITH (FILLFACTOR = 90)
);

