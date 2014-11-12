CREATE TABLE [dbo].[Coface_Rejeicao] (
    [cd_coface]      INT      NOT NULL,
    [cd_tipo_coface] INT      NOT NULL,
    [cd_usuario]     INT      NULL,
    [dt_usuario]     DATETIME NULL,
    CONSTRAINT [PK_Coface_Rejeicao] PRIMARY KEY CLUSTERED ([cd_coface] ASC, [cd_tipo_coface] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Coface_Rejeicao_Tipo_Coface] FOREIGN KEY ([cd_tipo_coface]) REFERENCES [dbo].[Tipo_Coface] ([cd_tipo_coface])
);

