CREATE TABLE [dbo].[rb_folder] (
    [folder_id]   INT          IDENTITY (1, 1) NOT NULL,
    [folder_name] VARCHAR (60) NOT NULL,
    [parent_id]   INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([folder_name] ASC, [parent_id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [folder_idx]
    ON [dbo].[rb_folder]([folder_id] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [parent_idx]
    ON [dbo].[rb_folder]([parent_id] ASC) WITH (FILLFACTOR = 90);

