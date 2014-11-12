CREATE TABLE [dbo].[Servico_Script] (
    [cd_servico] INT      NOT NULL,
    [cd_script]  INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Servico_Script] PRIMARY KEY CLUSTERED ([cd_servico] ASC, [cd_script] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Servico_Script_Script] FOREIGN KEY ([cd_script]) REFERENCES [dbo].[Script] ([cd_script])
);

