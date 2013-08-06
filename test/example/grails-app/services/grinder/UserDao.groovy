package grinder

import grails.plugin.dao.GormDaoSupport
import grails.plugin.dao.DomainException
import grails.plugin.dao.DaoUtil
import grails.plugin.dao.DaoMessage

class UserDao extends GormDaoSupport {
    Class domainClass = User

    def saveUserAndRole(User user, String role) {
        log.debug("Saving user ${user.login} with role ${role}")
        save(user)
    }

    def delete(entity) {
        super.delete(entity)
    }

    Map update(params) {
        println("update with $params")
        def user = User.get(params.id.toLong())
        // force init of the contact so we don't get "no session" when we try to access it
        def contact = user?.contact
        DaoUtil.checkFound(user, params, User.name)
        DaoUtil.checkVersion(user, params.version)
        persistWithParams(user, params)
        return [ok: true, entity: user, message: DaoMessage.updated(user)]
    }

    /**
     * Inserts and calls save for a new domain entity based with the data from params
     *
     * @param params the parameter map or json
     * @throws DomainException if a validation error happens
     */
    Map insert(params) {
        def user = new User()
        user.contact = new Contact()
        user.contact.org = Org.get(params.orgId)
        params.remove 'orgId'
        persistWithParams(user, params)

        return [ok: true, entity: user, message: DaoMessage.created(user)]
    }

    Map insertTest(params) {
        def user = new User()
        user.properties = params
        try {
            checkPasswordChange(user, params)
            save(user)
            DaoUtil.flush()
        } catch (DomainException e) {
            e.meta = [user: user]
            throw e
        }
        return [ok: true, entity: user, message: DaoMessage.created(user)]
    }

    void persistWithParams(user, params) {
        user.properties = params
        user.contact.properties['firstName', 'lastName', 'email', 'tagForReminders'] = params['contact']
        try {
            checkPasswordChange(user, params)
            user.contact.persist()
            save(user)
            DaoUtil.flush()
        } catch (DomainException e) {
            e.meta = [user: user]
            throw e
        }
    }

    /**
     * checks params to see if password exists, that is matches repassword and encodes it if so
     * finally setting it to the passwd field on User.
     */
    def checkPasswordChange(user, params) {
        if (params.password?.trim()) {
            if (params.password != params.repassword) {
                def msg = DaoMessage.setup("password.mismatch", [0], "The passwords you entered do not match")
                throw new DomainException(msg, user)
            } else {
                user.passwd = params.password
            }
        }
    }
}
