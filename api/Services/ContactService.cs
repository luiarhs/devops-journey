using Data;
using Models;

namespace Services;

public interface IContactService
{
    Task<List<Contact>> FindAllContactsAsync();
    Task<Contact> FindContactByIdAsync(Guid id);
    string GetPersonalContactFullName(Contact contact);
    Task<Guid> CreateContactAsync(Contact contact);
    Task UpdateContactAsync(Guid id, Contact updatedContact);
    Task DeleteContactAsync(Guid id);
}

public class ContactService : IContactService
{
    private readonly IContactRepository _repository;

    public ContactService(IContactRepository contactRepository)
    {
        _repository = contactRepository;
    }

    public async Task<List<Contact>> FindAllContactsAsync()
    {
        return await _repository.FindAllContactsAsync();
    }

    public async Task<Contact> FindContactByIdAsync(Guid id)
    {
        var contact = await _repository.FindContactByIdAsync(id);
        return contact;
    }

    public async Task<Guid> CreateContactAsync(Contact contact)
    {
        return await _repository.InsertAsync(contact);
    }

    public async Task UpdateContactAsync(Guid id, Contact updatedContact)
    {
        var existingContact = await _repository.FindContactByIdAsync(id);

        if (existingContact != null)
        {
            await _repository.UpdateAsync(updatedContact, existingContact);
        }
    }

    public async Task DeleteContactAsync(Guid id)
    {
        var existingContact = await _repository.FindContactByIdAsync(id);
        if (existingContact != null)
        {
            await _repository.DeleteAsync(existingContact);
        }
    }

    public string GetPersonalContactFullName(Contact contact)
    {
        if (contact is PersonalContact personalContact)
        {
            string fullName = $"{contact.FullName} {personalContact.Nickname}";
            return fullName;
        }
        return contact.FullName;
    }
}