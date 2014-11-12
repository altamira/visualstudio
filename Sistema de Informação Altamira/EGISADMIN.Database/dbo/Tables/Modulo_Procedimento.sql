CREATE TABLE [dbo].[Modulo_Procedimento] (
    [cd_modulo]                  INT          NOT NULL,
    [cd_procedimento]            INT          NOT NULL,
    [cd_modulo_procedimento]     INT          NOT NULL,
    [nm_obs_modulo_procedimento] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Modulo_Procedimento] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_procedimento] ASC, [cd_modulo_procedimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modulo_Procedimento_Procedimento] FOREIGN KEY ([cd_procedimento]) REFERENCES [dbo].[Procedimento] ([cd_procedimento])
);

