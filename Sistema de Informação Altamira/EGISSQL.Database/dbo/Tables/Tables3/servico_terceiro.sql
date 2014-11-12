CREATE TABLE [dbo].[servico_terceiro] (
    [cd_servico_terceiro] INT          NOT NULL,
    [nm_servico_terceiro] VARCHAR (40) NOT NULL,
    [sg_servico_terceiro] CHAR (15)    NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_servico_terceiro] PRIMARY KEY CLUSTERED ([cd_servico_terceiro] ASC) WITH (FILLFACTOR = 90)
);

