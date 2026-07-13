---------------------------------------------------------------------
-- Define here features that require a specific sm64coopdx version --
---------------------------------------------------------------------

local function require_version(major, minor)
    return (
        (VERSION_NUMBER > major) or
        (VERSION_NUMBER == major and MINOR_VERSION_NUMBER >= minor)
    )
end

return {
    GLOBAL_OBJECT_FIELDS = require_version(42, 2),
    MOD_AUDIO_OVERHAUL = require_version(42, 2),
}
