CREATE TABLE [dbo].[Modulo_Trigger] (
    [cd_modulo]             INT          NOT NULL,
    [cd_trigger]            INT          NOT NULL,
    [cd_modulo_trigger]     INT          NOT NULL,
    [nm_obs_modulo_trigger] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Modulo_Trigger] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_trigger] ASC, [cd_modulo_trigger] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modulo_Trigger_Trigger_] FOREIGN KEY ([cd_trigger]) REFERENCES [dbo].[Trigger_] ([cd_trigger])
);

