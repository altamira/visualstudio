CREATE TABLE [dbo].[Modulo_View] (
    [cd_modulo]          INT          NOT NULL,
    [cd_view]            INT          NOT NULL,
    [cd_modulo_view]     INT          NOT NULL,
    [nm_obs_modulo_view] VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Modulo_View] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_view] ASC, [cd_modulo_view] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modulo_View_View_] FOREIGN KEY ([cd_view]) REFERENCES [dbo].[View_] ([cd_view])
);

